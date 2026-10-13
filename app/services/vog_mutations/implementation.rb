# frozen_string_literal: true

module VOGMutations
  # The basic logic for an operation that powers a {Mutations::BaseMutation mutation}.
  #
  # Any given mutation operation gets set up by {VOGMutations::Executor} and
  # goes through several lifecycle methods:
  #
  # 1. `prepare` This step is for modifying the args and preparing the local context
  #   for later steps.
  # 2. `validation` The final major step before execution, this validates the args
  #   provided to the mutation along with any derived context.
  # 3. `contracts` A sub-step of validations, this is where
  #   {VOGMutations::Contracts#check_contracts! contracts are run} against the
  #   provided arguments. Failed contracts will add to the errors, which will prevent
  #   the final step from running at all.
  # 4. `execution` This is where the actual {#call logic of the mutation} is performed,
  #   assuming all validations and contracts passed and no other errors were set.
  #
  # All of these steps are defined as ActiveModel callbacks, so mutations can opt to
  # define hooks `before_contracts`, `around_execution`, etc.
  #
  # @abstract
  class Implementation
    extend ActiveModel::Callbacks

    include AfterCommitEverywhere
    include Dry::Monads[:result, :validated, :list]

    include VOGMutations::AttributeExtraction
    include VOGMutations::Authorization
    include VOGMutations::Contracts
    include VOGMutations::FlowControl
    include VOGMutations::ReadsCurrentMutation

    define_model_callbacks :mutation, :prepare, :authorization, :contracts, :validation, :execution

    # @abstract The main logic of the mutation must be implemented in this method.
    # @param [{ Symbol => Object }] args
    # @return [void] The return value is not acknowledged, as it
    #   is expected that values to be returned from the API are assigned to the
    #   response with {#attach!}. In case of failure, errors should be added
    #   to the response with {#add_global_error!} or similar methods.
    def call(**args)
      raise NotImplementedError, "Must implement #{self.class}#call"
    end

    # @api private
    # @see VOGMutations::Executor#call
    # @return [void]
    def execute!
      run_callbacks :mutation do
        execute_each_step!
      end
    end

    # @api private
    # @return [void]
    def execute_each_step!
      run_callbacks :prepare do
        prepare!
      end

      run_callbacks :authorization do
        authorize_mutation!
      end

      run_callbacks :validation do
        run_callbacks :contracts do
          check_contracts!
        end

        validate!
      end

      halt_if_errors!

      unset_transient_arguments!

      run_callbacks :execution do
        call(**execution_args)
      end
    end

    # @!group Hooks

    # @abstract
    # A hook that is called before everything else.
    # It can be used to set thing up for later steps.
    # @return [void]
    def prepare!
      mutation_state.set_up_execution_args!
    end

    # @abstract
    # A hook that checks for authorization to perform the mutation.
    #
    # Runs after prepare, but before validation.
    # @return [void]
    def authorize_mutation!; end

    # @abstract
    # A hook that performs custom validation logic.
    # Runs after contracts have been checked.
    # @return [void]
    def validate!; end

    # @!endgroup Hooks

    # @!group Model Persistence

    # A simple check that a model is valid, short-circuiting the mutation if not.
    #
    # @param [ApplicationRecord] model
    # @raise [VOGMutations::Halting::Invalid] if the model is invalid
    # @return [ApplicationRecord]
    def check_model!(model)
      return model if model.errors.none?

      invalid_model! model
    end

    # A helper to destroy a model, handling authorization and error reporting.
    def destroy_model!(model, auth: false)
      graphql_response[:destroyed] = false

      authorize model, :destroy? if auth

      id = model.to_encoded_id

      if model.destroy
        graphql_response[:destroyed] = true

        graphql_response[:destroyed_id] = id
      else
        invalid_model! model
      end
    end

    # @param [ApplicationRecord] model
    # @param [Symbol, nil] attach_to
    # @raise [VOGMutations::Halting::Invalid] if the model could not be persisted
    # @return [ApplicationRecord]
    def persist_model!(model, attach_to: nil)
      if model.save
        attach! attach_to, model

        return model
      else
        invalid_model! model
      end
    end

    # @param [Class<ApplicationRecord>] klass
    # @param [{ Symbol => Object }] attributes
    # @param [Array<Symbol>] unique_by
    # @param [Symbol, nil] attach_to
    # @return [ApplicationRecord]
    def upsert_model!(klass, attributes, unique_by:, attach_to: nil)
      result = klass.upsert(attributes, returning: unique_by, unique_by:)

      conditions = Array(unique_by).to_h do |key|
        [key.to_sym, result.pick(key.to_s)]
      end

      model = klass.find_by! conditions

      attach! attach_to, model

      return model
    end

    # @param [UsesStatesman] model
    # @param [Hash] raw_metadata
    # @return [Hash]
    def normalize_transition_metadata(model, **raw_metadata)
      model.class.default_transition_class.normalize_metadata(**raw_metadata)
    end

    # @param [UsesStatesman] model
    # @param [String, Symbol] state
    # @return [void]
    def transition_model_to!(model, state, attach_to: nil, **raw_transition_metadata)
      transition_metadata = normalize_transition_metadata(model, **raw_transition_metadata)

      model.transition_to! state, **transition_metadata
    rescue Statesman::TransitionFailedError => e
      error_message = e.message.presence || I18n.t("server_messages.errors.something_went_wrong")

      something_went_wrong!(error_message:)
    else
      model.current_state(force_reload: true)

      if attach_to
        attach! attach_to, model
      end
    end

    # @param [ApplicationRecord] model
    # @param [Symbol, nil] validation_context
    # @raise [VOGMutations::Halting::Invalid] if the model is invalid
    # @return [ApplicationRecord]
    def validate_model!(model, validation_context: nil)
      if model.valid? validation_context
        model
      else
        invalid_model! model
      end
    end

    # @api private
    # @param [ApplicationRecord] model
    # @raise [VOGMutations::Halting::Invalid]
    # @return [void]
    def invalid_model!(model)
      graphql_response.mark_invalid!

      add_model_errors! model

      throw_invalid
    end

    # @!endgroup Model Persistence

    # @!group Utility methods

    # @param [String] name the fully-qualified name of the operation
    # @param [<Object>] args the arguments for the operation (if any)
    # @return [Dry::Monads::Result] This is not guaranteed, but assumed for most operations
    #   that would be called by a mutation
    def call_operation(name, *args, **kwargs)
      Common::Container[name].call(*args, **kwargs)
    end

    # Call an operation by name and run through {#with_result!} in order
    # to easily handle its result.
    #
    # @note This differs from {#with_operation_result!} in that we inline the operation
    #   call and also allow the implementation to use its own resolution logic.
    # @param [String] name the fully-qualified name of the operation
    # @param [<Object>] args the arguments for the operation (if any)
    # @yield [matcher] handle the result of the operation based on `success` or `failure`
    # @yieldparam [Dry::Matcher::ResultMatcher] matcher
    # @yieldreturn [void]
    # @return [void]
    def with_called_operation!(name, *args, **kwargs, &)
      result = call_operation(name, *args, **kwargs)

      with_result!(result, &)
    end

    # @param [Dry::Monads::Result] result
    # @yield [matcher] instance of `Dry::Result::ResultMatcher`
    # @return [Object]
    def with_result!(result, &)
      Dry::Matcher::ResultMatcher.call(result, &)
    end

    # @param [Symbol] key the key to attach the result to in the response
    # @param [String] name the fully-qualified name of the operation to call
    # @param [<Object>] args the arguments for the operation (if any)
    # @param [Hash] kwargs the keyword arguments for the operation (if any)
    # @return [void]
    def attach_result_of!(key, name, *args, **kwargs)
      # simplecov:disable
      result = call_operation(name, *args, **kwargs)

      with_attached_result!(key, result)
      # simplecov:enable
    end

    # @see #something_went_wrong!
    # @param [Dry::Monads::Result] result
    # @param [String] error_message
    # @return [Object] if the result was successful, whatever was in the success monad will be returned
    def check_result!(result, error_message: I18n.t("server_messages.errors.something_went_wrong"))
      with_result!(result) do |m|
        m.success do |value|
          value
        end

        m.failure do
          something_went_wrong!(error_message:)
        end
      end
    end

    # @param [Dry::Monads::Result] result
    # @return [Object]
    def with_operation_result!(result)
      with_result!(result) do |m|
        m.success do |value|
          value
        end

        m.failure do |failure|
          handle_operation_failure! failure
        end
      end
    end

    # @param [Symbol] key
    # @param [Dry::Monads::Result] result
    # @return [void]
    def with_attached_result!(key, result)
      with_result! result do |m|
        m.success do |model|
          attach! key, model
        end

        m.failure do |(code, reason)|
          if reason.kind_of?(ApplicationRecord)
            invalid_model! reason
          end

          # simplecov:disable
          message = reason.kind_of?(String) ? reason : I18n.t("server_messages.errors.something_went_wrong")
          # simplecov:enable

          add_global_error! message, type: code.to_s.presence
        end
      end
    end

    # @!endgroup Utility methods
  end
end
