# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftUpdate
  class SolutionDraftUpdate < Mutations::MutateSolutionDraft
    description <<~TEXT
    Update a single `SolutionDraft` record.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to update.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_update"
  end
end
