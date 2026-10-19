# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionIntakeApprove
    class SolutionIntakeApprove < VOGMutations::Implementation
      use_contract! :solution_intake_approve

      authorizes! :solution_intake, with: :approve?

      # @param [SolutionIntake] solution_intake
      # @param [String, nil] note
      # @return [void]
      def call(solution_intake:, note: nil)
        solution_intake.approve(current_user:, note:, source: "admin") do |m|
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
