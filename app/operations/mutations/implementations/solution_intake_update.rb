# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionIntakeUpdate
    class SolutionIntakeUpdate < VOGMutations::Implementation
      use_contract! :solution_intake_update
      use_contract! :mutate_solution_intake

      authorizes! :solution_intake, with: :update?

      # Saves progress like the public intake form: the editor validations wait for submission.
      #
      # @param [SolutionIntake] solution_intake
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(solution_intake:, **attrs)
        assign_attributes!(solution_intake, **attrs)

        persist_model! solution_intake, attach_to: :solution_intake
      end
    end
  end
end
