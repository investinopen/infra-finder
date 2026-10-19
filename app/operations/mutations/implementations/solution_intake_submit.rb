# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionIntakeSubmit
    class SolutionIntakeSubmit < VOGMutations::Implementation
      use_contract! :solution_intake_submit

      authorizes! :solution_intake, with: :submit?

      # Non-admins submit like the public intake form, which checks the editor validations;
      # admins can skip them, as in ActiveAdmin.
      #
      # @param [SolutionIntake] solution_intake
      # @param [String, nil] note
      # @return [void]
      def call(solution_intake:, note: nil)
        admin = current_user.has_any_admin_access?

        unless admin
          solution_intake.apply_editor_validations = true

          validate_model! solution_intake
        end

        solution_intake.submit(current_user:, note:, source: admin ? "admin" : "form") do |m|
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
