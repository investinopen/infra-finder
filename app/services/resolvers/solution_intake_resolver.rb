# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionIntake}.
  #
  # @see SolutionIntake
  # @see Types::SolutionIntakeType
  class SolutionIntakeResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsSolutionIntake

    applies_policy_scope!

    type ::Types::SolutionIntakeType.connection_type, null: false

    resolves_model! ::SolutionIntake

    filters_with! ::Filtering::Scopes::SolutionIntakes
  end
end
