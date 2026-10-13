# frozen_string_literal: true

module VOGMutations
  # The minimum amount needed to run a {VOGMutations::Contract}.
  #
  # This class mostly exists to simplify testing, as the values herein are set
  # by the more extensive {VOGMutations::Executor}.
  #
  # @api private
  # @see VOGMutations::State
  # @see ::Support::Requests::Current
  class ContractExecutor
    include Dry::Initializer[undefined: false].define -> do
      option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT
      option :local_context, Support::GlobalTypes::Hash, default: proc { {} }
    end

    # @return [VOGMutations::State]
    attr_reader :state

    def initialize(...)
      super

      @state = VOGMutations::State.new(
        current_user:,
        local_context:
      )
    end

    # @return [void]
    def call
      VOGMutations.with_active!(state:) do
        yield
      end
    end
  end
end
