# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftRequestReview
  class SolutionDraftRequestReview < SolutionDraftTransition
    description <<~TEXT
    Submit a pending draft for an admin to review.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to submit for review.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_request_review"
  end
end
