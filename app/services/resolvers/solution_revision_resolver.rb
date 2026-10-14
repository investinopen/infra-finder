# frozen_string_literal: true

module Resolvers
  # A resolver for a {SolutionRevision}.
  #
  # @see SolutionRevision
  # @see Types::SolutionRevisionType
  class SolutionRevisionResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsSolutionRevision

    applies_policy_scope!

    type ::Types::SolutionRevisionType.connection_type, null: false

    resolves_model! ::SolutionRevision
  end
end
