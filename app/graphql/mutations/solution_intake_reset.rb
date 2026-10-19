# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionIntakeReset
  class SolutionIntakeReset < SolutionIntakeTransition
    description <<~TEXT
    Return an intake in review or rejected to pending, so its form can be changed again.
    TEXT

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to reset.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_intake_reset"
  end
end
