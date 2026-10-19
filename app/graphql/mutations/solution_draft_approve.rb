# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftApprove
  class SolutionDraftApprove < SolutionDraftTransition
    description <<~TEXT
    Approve a draft in review, applying its changes to its solution and publishing the solution.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to approve.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_approve"
  end
end
