# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionCreateDraft
  class SolutionCreateDraft < Mutations::BaseMutation
    description <<~TEXT
    Start a draft of changes to a solution. A user can have only one pending draft per solution.
    TEXT

    field :solution_draft, Types::SolutionDraftType, null: true do
      description <<~TEXT
      The new draft, if successful.
      TEXT
    end

    argument :solution_id, ID, loads: Types::SolutionType, required: true do
      description <<~TEXT
      The solution to draft changes to.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_create_draft"
  end
end
