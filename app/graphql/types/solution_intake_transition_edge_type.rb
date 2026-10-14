# frozen_string_literal: true

module Types
  # An edge in a {::Types::SolutionIntakeTransitionConnectionType} for {SolutionIntakeTransition}-type records.
  #
  # @see SolutionIntakeTransition
  # @see Types::SolutionIntakeTransitionConnectionType
  # @see Types::SolutionIntakeTransitionType
  class SolutionIntakeTransitionEdgeType < Types::BaseEdge
    description <<~TEXT
    An edge in a connection for `SolutionIntakeTransition`.
    TEXT

    node_type ::Types::SolutionIntakeTransitionType
  end
end
