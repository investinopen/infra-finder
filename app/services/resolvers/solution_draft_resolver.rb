# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionDraft}.
  #
  # @see SolutionDraft
  # @see Types::SolutionDraftType
  class SolutionDraftResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsSolutionDraft

    applies_policy_scope!

    type ::Types::SolutionDraftType.connection_type, null: false

    resolves_model! ::SolutionDraft

    filters_with! ::Filtering::Scopes::SolutionDrafts
  end
end
