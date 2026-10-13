# frozen_string_literal: true

module Resolvers
  # A resolver for a {InvitationTransition}.
  #
  # @see Invitation
  # @see InvitationTransition
  # @see ::Types::InvitationTransitionType
  class InvitationTransitionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    applies_policy_scope!

    type ::Types::InvitationTransitionType.connection_type, null: false

    resolves_model! ::InvitationTransition do
      object.invitation_transitions.in_graphql_order
    end
  end
end
