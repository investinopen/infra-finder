# frozen_string_literal: true

module Resolvers
  # A resolver for a {Solution}.
  #
  # @see Solution
  # @see Types::SolutionType
  class SolutionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsSolution

    applies_policy_scope!

    type ::Types::SolutionType.connection_type, null: false

    resolves_model! ::Solution

    filters_with! ::Filtering::Scopes::Solutions
  end
end
