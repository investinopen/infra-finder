# frozen_string_literal: true

module Types
  # @see SolutionDraftTransition
  # @see ::Types::SolutionDraftTransitionConnectionType
  # @see ::Types::SolutionDraftTransitionEdgeType
  class SolutionDraftTransitionType < Types::AbstractModel
    description <<~TEXT
    A transition for a `SolutionDraft`.
    TEXT

    use_direct_connection_and_edge!

    implements ::Types::CommonTransitionType

    field :from_state, Types::SolutionDraftStateType, null: true do
      description <<~TEXT
      The state that the solution draft is transitioning from. This will be null if the submission target is being created.
      TEXT
    end

    field :to_state, Types::SolutionDraftStateType, null: false do
      description <<~TEXT
      The state that the solution draft is transitioning to.
      TEXT
    end

    field :memo, String, null: true do
      description <<~TEXT
      The memo associated with the transition.
      TEXT
    end
  end
end
