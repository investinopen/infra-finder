# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionIntakeReset
    class SolutionIntakeReset < VOGMutations::Implementation
      use_contract! :solution_intake_reset

      authorizes! :solution_intake, with: :reset?

      # @param [SolutionIntake] solution_intake
      # @param [String, nil] note
      # @return [void]
      def call(solution_intake:, note: nil)
        solution_intake.reset(current_user:, note:, source: "admin") do |m|
          m.success do
            attach! :solution_intake, solution_intake
          end

          m.failure do
            something_went_wrong!
          end
        end
      end
    end
  end
end
