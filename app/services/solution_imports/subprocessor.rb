# frozen_string_literal: true

module SolutionImports
  # @abstract
  class Subprocessor < Support::HookBased::Actor
    extend Dry::Initializer

    include Dry::Effects.Interrupt(:mark_invalid)

    include Dry::Effects.Reader(:context)
    include Dry::Effects.Reader(:logger)
    include Dry::Effects.Reader(:strategy)

    include Dry::Effects.Resolve(:import)
    include Dry::Effects.Resolve(:user)

    include MonadicPersistence
    include MonadicTransitions

    standard_execution!

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield perform!
      end

      Success()
    end

    wrapped_hook! :prepare

    wrapped_hook! :perform

    def should_benchmark?
      Rails.env.local?
    end
  end
end
