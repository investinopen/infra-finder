# frozen_string_literal: true

module VOGMutations
  # A concern that provides accessors for the current mutation, state, and response.
  #
  # @see VOGMutations::Current
  module ReadsCurrentMutation
    extend ActiveSupport::Concern

    include VOGMutations::FlowControl

    # @!group Accessors

    # @!attribute [r] graphql_response
    # @api private
    # @return [VOGMutations::Response]
    def graphql_response
      VOGMutations::Current.response
    end

    # @!attribute [r] state
    # @api private
    # @return [VOGMutations::State]
    def mutation_state
      VOGMutations::Current.state
    end

    # @!endgroup Accessors

    # @return [void]
    def halt_if_errors!
      # simplecov:disable
      throw_invalid if has_errors?
      # simplecov:enable
    end

    delegate :graphql_context,
      :argument_set,
      :authorizer,
      :local_context,
      :current_user,
      :transient_arguments,
      :error_compiler,
      :unset_transient_arguments!,
      :args, :execution_args,
      to: :mutation_state

    delegate(
      :attach!,
      :attach_many!,
      :attached?,
      :has_errors?,
      :add_attribute_error!,
      :add_global_error!,
      :add_global_validation_error!,
      :add_model_errors!,
      :handle_operation_failure!,
      :something_went_wrong!,
      to: :graphql_response
    )
  end
end
