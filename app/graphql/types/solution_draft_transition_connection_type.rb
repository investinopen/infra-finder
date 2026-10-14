# frozen_string_literal: true

module Types
  # A connection type for {SolutionDraftTransition}-typed records.
  #
  # @see SolutionDraftTransition
  # @see ::Types::SolutionDraftTransitionEdgeType
  # @see ::Types::SolutionDraftTransitionType
  class SolutionDraftTransitionConnectionType < Types::BaseConnection
    graphql_name "SolutionDraftTransitionConnection"

    description <<~TEXT
    A connection type for `SolutionDraftTransition`.
    TEXT

    edge_type ::Types::SolutionDraftTransitionEdgeType
  end
end
