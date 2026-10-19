# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionIntakeReject
  class SolutionIntakeReject < SolutionIntakeTransition
    description <<~TEXT
    Reject an intake in review. It can be reset later.
    TEXT

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to reject.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_intake_reject"
  end
end
