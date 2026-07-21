# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approve
  class Approver < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :intake, Types::Intake
    end

    standard_execution!

    # @return [Solution]
    attr_reader :solution

    # @return [Dry::Monads::Success(SolutionIntake)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield assign_attributes!

        yield approve!
      end

      Success intake
    end

    wrapped_hook! def prepare
      @solution = intake.solution

      super
    end

    wrapped_hook! def assign_attributes
      yield intake.assign

      @solution = intake.reload_solution

      super
    end

    wrapped_hook! def approve
      intake.transition_to! :approved

      super
    end
  end
end
