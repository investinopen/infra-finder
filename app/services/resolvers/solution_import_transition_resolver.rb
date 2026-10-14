# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionImportTransition}.
  #
  # @see SolutionImport
  # @see SolutionImportTransition
  # @see ::Types::SolutionImportTransitionType
  class SolutionImportTransitionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    applies_policy_scope!

    type ::Types::SolutionImportTransitionType.connection_type, null: false

    resolves_model! ::SolutionImportTransition do
      object.solution_import_transitions.in_graphql_order
    end
  end
end
