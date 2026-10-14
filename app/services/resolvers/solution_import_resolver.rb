# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionImport}.
  #
  # @see SolutionImport
  # @see Types::SolutionImportType
  class SolutionImportResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsSolutionImport

    applies_policy_scope!

    type ::Types::SolutionImportType.connection_type, null: false

    resolves_model! ::SolutionImport

    filters_with! ::Filtering::Scopes::SolutionImports
  end
end
