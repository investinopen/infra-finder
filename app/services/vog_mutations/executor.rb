# frozen_string_literal: true

module VOGMutations
  # Executes a {VOGMutations::Implementation} within a proper context,
  # handling transactions, halting, and building the final response.
  class Executor
    extend ActiveModel::Callbacks

    include Dry::Effects::Handler.Reader(:vog_mutation, as: :with_effects_frame)
    include Dry::Matcher.for(:resolve, with: Dry::Matcher::ResultMatcher)
    include Dry::Monads[:result]

    include Dry::Initializer[undefined: false].define -> do
      param :operation, Types.Instance(VOGMutations::Implementation)

      option :argument_set, VOGMutations::Arguments::Set::Type, default: -> { VOGMutations::Arguments::Set.new }
      option :context, Types::QueryContext, default: -> { Types::BUILD_NULL_CONTEXT.() }
      option :mutation, Types.Instance(Mutations::BaseMutation).optional, optional: true
      option :operation_name, Types::String.optional
      option :provided_args, Types::Hash, default: -> { Dry::Core::Constants::EMPTY_HASH }
    end

    delegate :error_compiler, :transient_arguments, to: :argument_set

    alias graphql_context context

    define_model_callbacks :execute

    # @return [:invalid, :unauthorized, nil]
    attr_reader :halt_code

    # @return [VOGMutations::Response]
    attr_reader :response

    # @return [Boolean]
    attr_reader :rolled_back

    alias rolled_back? rolled_back

    # @return [VOGMutations::State]
    attr_reader :state

    around_execute :set_execution_context!

    around_execute :with_transaction!

    around_execute :watch_for_halt!

    def initialize(...)
      super

      @halt_code = nil

      @response = VOGMutations::Response.new(error_compiler:)

      @rolled_back = false

      @state = VOGMutations::State.new(**build_state_args)
    end

    # @return [Hash, GraphQL::ExecutionError]
    def call
      execute!

      resolve do |m|
        m.success do
          response.to_h
        end

        m.failure(:invalid) do
          response[:halt_code] ||= "invalid"

          response.to_h
        end

        m.failure(:unauthorized) do
          build_execution_error(I18n.t("server_messages.auth.forbidden"), code: "FORBIDDEN")
        end

        m.failure do
          # simplecov:disable
          build_execution_error(I18n.t("server_messages.errors.something_went_wrong"))
          # simplecov:enable
        end
      end
    end

    # @api private
    # @return [void]
    def execute!
      # dry-effects runs the outermost handler in a fiber of its own, and with fiber
      # isolation each fiber leases its own database connection. Opening a handler
      # before the transaction keeps nested handlers (every hook-based actor, for one)
      # in this fiber and on the transaction's connection. Otherwise their writes
      # escape the transaction, or block forever on rows it has locked.
      with_effects_frame(self) do
        run_callbacks :execute do
          operation.execute!
        end
      end
    end

    # @return [Dry::Monads::Result]
    def resolve
      case halt_code
      in nil
        Success[:ok]
      in :invalid
        Failure[:invalid]
      in :unauthorized
        Failure[:unauthorized]
      else
        # simplecov:disable
        Failure[:internal_server_error]
        # simplecov:enable
      end
    end

    private

    # @param [String] message
    # @param [String] code
    # @return [GraphQL::ExecutionError]
    def build_execution_error(message, code: "INTERNAL_SERVER_ERROR")
      extensions = { code:, }

      GraphQL::ExecutionError.new(message, extensions:)
    end

    # @see VOGMutations::State
    # @return [Hash]
    def build_state_args
      {
        argument_set:,
        current_user:,
        graphql_context:,
        provided_args:,
      }
    end

    # @!attribute [r] current_user
    # @return [User, AnonymousUser]
    def current_user
      context[:current_user].presence || AnonymousUser.new
    end

    # @param [Symbol] code
    # @return [void]
    def halt_because!(code)
      @halt_code = code
      @rolled_back = true

      raise ActiveRecord::Rollback
    end

    # @return [void]
    def set_execution_context!
      VOGMutations.with_active!(response:, state:) do
        yield
      end
    end

    # @see #halt_because!
    # @raise [ActiveRecord::Rollback] if halted
    # @return [void]
    def watch_for_halt!
      yield
    rescue VOGMutations::Halting::Invalid
      halt_because! :invalid
    rescue VOGMutations::Halting::Unauthorized
      halt_because! :unauthorized
    end

    # @return [void]
    def with_transaction!
      ApplicationRecord.transaction do
        yield
      end
    end
  end
end
