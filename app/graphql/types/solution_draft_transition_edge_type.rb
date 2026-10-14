# frozen_string_literal: true

module Types
  # An edge in a {::Types::SolutionDraftTransitionConnectionType} for {SolutionDraftTransition}-type records.
  #
  # @see SolutionDraftTransition
  # @see Types::SolutionDraftTransitionConnectionType
  # @see Types::SolutionDraftTransitionType
  class SolutionDraftTransitionEdgeType < Types::BaseEdge
    description <<~TEXT
    An edge in a connection for `SolutionDraftTransition`.
    TEXT

    node_type ::Types::SolutionDraftTransitionType
  end
end
