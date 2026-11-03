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

          m.failure(:incomplete) do
            # This mutation takes no field arguments, so paths come from the ones that edit the intake.
            invalid_model! solution_intake, argument_set: ::Mutations::MutateSolutionIntake.argument_set
          end

          m.failure do
            something_went_wrong!
          end
        end
      end
    end
  end
end
