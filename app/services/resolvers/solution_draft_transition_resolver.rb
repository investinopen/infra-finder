# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionDraftTransition}.
  #
  # @see SolutionDraft
  # @see SolutionDraftTransition
  # @see ::Types::SolutionDraftTransitionType
  class SolutionDraftTransitionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    applies_policy_scope!

    type ::Types::SolutionDraftTransitionType.connection_type, null: false

    resolves_model! ::SolutionDraftTransition do
      object.solution_draft_transitions.in_graphql_order
    end
  end
end
