# frozen_string_literal: true

module Resolvers
  # A resolver for a {Invitation}.
  #
  # @see Invitation
  # @see Types::InvitationType
  class InvitationResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsInvitation

    applies_policy_scope!

    type ::Types::InvitationType.connection_type, null: false

    resolves_model! ::Invitation

    filters_with! ::Filtering::Scopes::Invitations
  end
end
