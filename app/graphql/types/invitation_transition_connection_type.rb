# frozen_string_literal: true

module Types
  # A connection type for {InvitationTransition}-typed records.
  #
  # @see InvitationTransition
  # @see ::Types::InvitationTransitionEdgeType
  # @see ::Types::InvitationTransitionType
  class InvitationTransitionConnectionType < Types::BaseConnection
    graphql_name "InvitationTransitionConnection"

    description <<~TEXT
    A connection type for `InvitationTransition`.
    TEXT

    edge_type ::Types::InvitationTransitionEdgeType
  end
end
