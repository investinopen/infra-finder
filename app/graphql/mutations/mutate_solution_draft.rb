# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::SolutionDraftCreate
  # @see Mutations::SolutionDraftUpdate
  class MutateSolutionDraft < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `solutionDraftCreate` and `solutionDraftUpdate`.
    TEXT

    field :solution_draft, Types::SolutionDraftType, null: true do
      description <<~TEXT
      The newly-modified solution draft, if successful.
      TEXT
    end

    shared_argument_set Mutations::Shared::SolutionDraftAttributes
  end
end
