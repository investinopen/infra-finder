# frozen_string_literal: true

module Mutations
  # @abstract
  class SolutionDraftTransition < Mutations::BaseMutation
    description <<~TEXT
    Move a draft through its review workflow.
    TEXT

    field :solution_draft, Types::SolutionDraftType, null: true do
      description <<~TEXT
      The draft in its new state, if successful.
      TEXT
    end

    argument :solution_draft_id, ID, loads: Types::SolutionDraftType, required: true do
      description <<~TEXT
      The solution draft to transition.
      TEXT
    end

    argument :memo, String, required: false do
      description <<~TEXT
      A message for the transition, included in its history and notifications.
      TEXT
    end
  end
end
