# frozen_string_literal: true

module Resolvers
  # A resolver for a {User}.
  #
  # @see User
  # @see Types::UserType
  class UserResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsUser

    applies_policy_scope!

    type ::Types::UserType.connection_type, null: false

    resolves_model! ::User

    filters_with! ::Filtering::Scopes::Users
  end
end
