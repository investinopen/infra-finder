# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionIntakeTransition}.
  #
  # @see SolutionIntake
  # @see SolutionIntakeTransition
  # @see ::Types::SolutionIntakeTransitionType
  class SolutionIntakeTransitionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    applies_policy_scope!

    type ::Types::SolutionIntakeTransitionType.connection_type, null: false

    resolves_model! ::SolutionIntakeTransition do
      object.solution_intake_transitions.in_graphql_order
    end
  end
end
