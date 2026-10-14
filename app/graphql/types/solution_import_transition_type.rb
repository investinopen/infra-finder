# frozen_string_literal: true

module Types
  # @see SolutionImportTransition
  # @see ::Types::SolutionImportTransitionConnectionType
  # @see ::Types::SolutionImportTransitionEdgeType
  class SolutionImportTransitionType < Types::AbstractModel
    description <<~TEXT
    A transition for a `SolutionImport`.
    TEXT

    use_direct_connection_and_edge!

    implements ::Types::CommonTransitionType

    field :from_state, Types::SolutionImportStateType, null: true do
      description <<~TEXT
      The state that the solution import is transitioning from. This will be null if the submission target is being created.
      TEXT
    end

    field :to_state, Types::SolutionImportStateType, null: false do
      description <<~TEXT
      The state that the solution import is transitioning to.
      TEXT
    end
  end
end
