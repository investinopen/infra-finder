# frozen_string_literal: true

module Types
  # A connection type for {SolutionImportTransition}-typed records.
  #
  # @see SolutionImportTransition
  # @see ::Types::SolutionImportTransitionEdgeType
  # @see ::Types::SolutionImportTransitionType
  class SolutionImportTransitionConnectionType < Types::BaseConnection
    graphql_name "SolutionImportTransitionConnection"

    description <<~TEXT
    A connection type for `SolutionImportTransition`.
    TEXT

    edge_type ::Types::SolutionImportTransitionEdgeType
  end
end
