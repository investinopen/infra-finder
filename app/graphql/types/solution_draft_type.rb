# frozen_string_literal: true

module Types
  # @see SolutionDraft
  class SolutionDraftType < Types::AbstractModel
    description <<~TEXT
    Proposed changes to a `Solution`, which an admin reviews before they are applied.
    TEXT

    implements ::Types::SolutionInterfaceType

    field :identifier, String, null: false do
      description "A unique, human-readable identifier for the draft."
    end

    field :current_state, ::Types::SolutionDraftStateType, null: false do
      description "The current state of the draft."
    end

    field :solution, "::Types::SolutionType", null: true do
      description "The solution the draft changes."
    end

    field :user, "::Types::UserType", null: true do
      description "The user who created the draft."
    end

    field :changed_properties, [::Types::SolutionPropertyType, { null: false }], null: false do
      description <<~TEXT
      The properties the draft changes. Read each one's `fieldName` from the draft and from its
      solution to compare the values.
      TEXT
    end

    field :transitions, resolver: ::Resolvers::SolutionDraftTransitionResolver do
      description "The history of the draft's state changes."
    end

    load_association! :solution
    load_association! :user
    load_association! :solution_draft_transitions, as: :transitions_for_state
    load_current_state! from: :transitions_for_state

    # @return [<SolutionProperty>]
    def changed_properties
      SolutionProperty.changed_by(object)
    end
  end
end
