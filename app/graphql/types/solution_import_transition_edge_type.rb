# frozen_string_literal: true

module Types
  # An edge in a {::Types::SolutionImportTransitionConnectionType} for {SolutionImportTransition}-type records.
  #
  # @see SolutionImportTransition
  # @see Types::SolutionImportTransitionConnectionType
  # @see Types::SolutionImportTransitionType
  class SolutionImportTransitionEdgeType < Types::BaseEdge
    description <<~TEXT
    An edge in a connection for `SolutionImportTransition`.
    TEXT

    node_type ::Types::SolutionImportTransitionType
  end
end
