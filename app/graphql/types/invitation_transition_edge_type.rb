# frozen_string_literal: true

module Types
  # An edge in a {::Types::InvitationTransitionConnectionType} for {InvitationTransition}-type records.
  #
  # @see InvitationTransition
  # @see Types::InvitationTransitionConnectionType
  # @see Types::InvitationTransitionType
  class InvitationTransitionEdgeType < Types::BaseEdge
    description <<~TEXT
    An edge in a connection for `InvitationTransition`.
    TEXT

    node_type ::Types::InvitationTransitionType
  end
end
