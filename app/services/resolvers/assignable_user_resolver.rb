# frozen_string_literal: true

module Resolvers
  # Resolves the users who can be made editors of a {Provider}.
  #
  # @see User.assignable_to
  class AssignableUserResolver < UserResolver
    resolves_model! ::User, association_name: :assignable_users
  end
end
