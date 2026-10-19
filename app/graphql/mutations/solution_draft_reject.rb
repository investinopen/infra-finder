# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftReject
  class SolutionDraftReject < SolutionDraftTransition
    description <<~TEXT
    Reject a draft in review, locking it from further changes while keeping its history.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to reject.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_reject"
  end
end
