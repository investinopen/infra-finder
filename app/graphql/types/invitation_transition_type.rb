# frozen_string_literal: true

module Types
  # @see InvitationTransition
  # @see ::Types::InvitationTransitionConnectionType
  # @see ::Types::InvitationTransitionEdgeType
  class InvitationTransitionType < Types::AbstractModel
    description <<~TEXT
    A transition for a `Invitation`.
    TEXT

    use_direct_connection_and_edge!

    implements ::Types::CommonTransitionType

    field :from_state, Types::InvitationStateType, null: true do
      description <<~TEXT
      The state that the invitation is transitioning from. This will be null if the submission target is being created.
      TEXT
    end

    field :to_state, Types::InvitationStateType, null: false do
      description <<~TEXT
      The state that the invitation is transitioning to.
      TEXT
    end
  end
end
