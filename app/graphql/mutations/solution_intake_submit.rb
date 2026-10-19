# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionIntakeSubmit
  class SolutionIntakeSubmit < SolutionIntakeTransition
    description <<~TEXT
    Submit a pending intake for review. Unless the current user is an admin, the intake must pass the intake form's validations.
    TEXT

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to submit.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_intake_submit"
  end
end
