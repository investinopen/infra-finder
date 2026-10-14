# frozen_string_literal: true

module Types
  # @see SolutionIntake
  class SolutionIntakeType < Types::AbstractModel
    description <<~TEXT
    A submission of a new solution, filled in through the public intake form and reviewed by an admin.
    TEXT

    implements ::Types::SolutionInterfaceType

    field :snowflake, String, null: false do
      description "The identifier used in the intake form's link."
    end

    field :current_state, ::Types::SolutionIntakeStateType, null: false do
      description "The current state of the intake."
    end

    field :solution, "::Types::SolutionType", null: true do
      description "The solution created when the intake was approved."
    end

    field :editor, "::Types::UserType", null: true do
      description "The editor who submitted the intake, if any."
    end

    field :transitions, resolver: ::Resolvers::SolutionIntakeTransitionResolver do
      description "The history of the intake's state changes."
    end

    load_association! :solution
    load_association! :editor
    load_association! :solution_intake_transitions, as: :transitions_for_state
    load_current_state! from: :transitions_for_state

    # @return [String]
    def snowflake = object.snowflake.to_s
  end
end
