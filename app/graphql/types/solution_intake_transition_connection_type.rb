# frozen_string_literal: true

module Types
  # A connection type for {SolutionIntakeTransition}-typed records.
  #
  # @see SolutionIntakeTransition
  # @see ::Types::SolutionIntakeTransitionEdgeType
  # @see ::Types::SolutionIntakeTransitionType
  class SolutionIntakeTransitionConnectionType < Types::BaseConnection
    graphql_name "SolutionIntakeTransitionConnection"

    description <<~TEXT
    A connection type for `SolutionIntakeTransition`.
    TEXT

    edge_type ::Types::SolutionIntakeTransitionEdgeType
  end
end
