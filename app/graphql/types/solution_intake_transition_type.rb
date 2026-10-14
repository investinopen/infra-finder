# frozen_string_literal: true

module Types
  # @see SolutionIntakeTransition
  # @see ::Types::SolutionIntakeTransitionConnectionType
  # @see ::Types::SolutionIntakeTransitionEdgeType
  class SolutionIntakeTransitionType < Types::AbstractModel
    description <<~TEXT
    A transition for a `SolutionIntake`.
    TEXT

    use_direct_connection_and_edge!

    implements ::Types::CommonTransitionType

    field :from_state, Types::SolutionIntakeStateType, null: true do
      description <<~TEXT
      The state that the solution intake is transitioning from. This will be null if the submission target is being created.
      TEXT
    end

    field :to_state, Types::SolutionIntakeStateType, null: false do
      description <<~TEXT
      The state that the solution intake is transitioning to.
      TEXT
    end
  end
end
