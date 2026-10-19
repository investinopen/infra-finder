# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionIntakeApprove
  class SolutionIntakeApprove < SolutionIntakeTransition
    description <<~TEXT
    Approve an intake in review, creating its solution (unpublished). The intake must have a provider.
    TEXT

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to approve.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_intake_approve"
  end
end
