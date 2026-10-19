# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDraftDestroy
  class SolutionDraftDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `SolutionDraft` record.
    TEXT

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_draft_destroy", destroy: true
  end
end
