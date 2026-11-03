# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionIntakeSubmit
    class SolutionIntakeSubmit < VOGMutations::Implementation
      use_contract! :solution_intake_submit

      authorizes! :solution_intake, with: :submit?

      # Every user, admin or not, can only submit a complete intake.
      #
      # @param [SolutionIntake] solution_intake
      # @param [String, nil] note
      # @return [void]
      def call(solution_intake:, note: nil)
        admin = current_user.has_any_admin_access?

        solution_intake.submit(current_user:, note:, source: admin ? "admin" : "form") do |m|
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
