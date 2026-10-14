# frozen_string_literal: true

module Types
  # @see ::SolutionDraft
  # @see ::SolutionDraftTransition
  # @see ::SolutionDrafts::StateMachine
  class SolutionDraftStateType < Types::BaseEnum
    description <<~TEXT
    The current state of a `SolutionDraft`.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      The solution draft is in the `pending` state.
      TEXT
    end

    value "IN_REVIEW", value: "in_review" do
      description <<~TEXT
      The solution draft is in the `in review` state.
      TEXT
    end

    value "APPROVED", value: "approved" do
      description <<~TEXT
      The solution draft is in the `approved` state.
      TEXT
    end

    value "REJECTED", value: "rejected" do
      description <<~TEXT
      The solution draft is in the `rejected` state.
      TEXT
    end
  end
end
