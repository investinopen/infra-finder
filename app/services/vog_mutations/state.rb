# frozen_string_literal: true

module VOGMutations
  # A state object for the current mutation execution.
  # It holds various contexts and arguments needed during execution,
  # and gets exposed via {VOGMutations::Current}.
  #
  # @see VOGMutations::Implementation
  # @see VOGMutations::ReadsCurrentMutation
  class State
    include Dry::Initializer[undefined: false].define -> do
      option :argument_set, VOGMutations::Arguments::Set::Type, default: -> { VOGMutations::Arguments::Set.new }
      option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT_FROM_REQUEST
      option :graphql_context, Types::QueryContext, default: -> { Types::BUILD_NULL_CONTEXT.(current_user:) }
      option :local_context, Types::LocalContext, default: -> { {} }
      option :provided_args, Types::Hash, default: proc { {} }
    end

    delegate :error_compiler, :transient_arguments, to: :argument_set

    # @return [{ Symbol => Object }]
    attr_reader :args

    # @return [VOGMutations::Authorizer]
    attr_reader :authorizer

    # @return [{ Symbol => Object }]
    attr_reader :execution_args

    def initialize(...)
      super

      set_up_args!
      set_up_execution_args!
      set_up_authorizer!
    end

    # @return [void]
    def set_up_authorizer!
      @authorizer = VOGMutations::Authorizer.new(current_user:)
    end

    # @!group Execution Args Management

    # @return [void]
    def set_up_execution_args!
      @execution_args = args.dup.deep_symbolize_keys
    end

    # @param [<Symbol>] keys
    # @return [void]
    def unset_arg_for_execution!(*keys)
      keys.flatten.each do |key|
        execution_args.delete key
      end
    end

    # @return [void]
    def unset_transient_arguments!
      return if transient_arguments.none?

      unset_arg_for_execution!(*transient_arguments)
    end

    # @!endgroup Execution Args Management

    private

    # @return [void]
    def set_up_args!
      local_context[:args] = provided_args

      @args = provided_args.dup.deep_symbolize_keys
    end
  end
end
