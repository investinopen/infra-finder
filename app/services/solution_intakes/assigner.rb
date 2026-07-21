# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Assign
  class Assigner < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :intake, Types::Intake
    end

    delegate :provider, to: :intake

    standard_execution!

    # @return [Solution]
    attr_reader :solution

    # @return [Dry::Monads::Result]
    def call
      run_callbacks :execute do
        yield prepare!

        yield assign_attributes!
      end

      Success()
    end

    wrapped_hook! def prepare
      @solution = intake.solution || create_solution!

      super
    end

    wrapped_hook! def assign_attributes
      yield InfraFinder::Container["solutions.assign_attributes"].(intake, solution)

      super
    end

    private

    # @return [Solution]
    def create_solution!
      solution = Solution.new(name: intake.name, provider:)

      solution.save!

      intake.update_column :solution_id, solution.id

      return solution
    end
  end
end
