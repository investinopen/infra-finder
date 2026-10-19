# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftRequestRevision
  class SolutionDraftRequestRevision < SolutionDraftTransition
    description <<~TEXT
    Send a draft in review back to pending, so its editor can make further changes.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to send back.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_request_revision"
  end
end
