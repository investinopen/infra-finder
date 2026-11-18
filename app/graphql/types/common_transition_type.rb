# frozen_string_literal: true

module Types
  # @see CommonTransition
  module CommonTransitionType
    include Types::BaseInterface

    description <<~TEXT
    A common interface for transition models, which represent state changes in a state machine.
    These models have `from_state`, `to_state`, and `most_recent` fields, as well as an optional
    association to a `User` who performed the transition.
    TEXT

    field :most_recent, Boolean, null: false do
      description <<~TEXT
      Whether this is the most recent transition.
      TEXT
    end

    field :initiator, "::Types::UserType" do
      description <<~TEXT
      The user who performed the transition, if available.

      Some transitions may happen through automated processes, so the user will not always be set.
      TEXT
    end

    field :user, "::Types::UserType", deprecation_reason: "Use `incitingUser` instead." do
      description <<~TEXT
      Formerly the user who performed the transition.

      Use `initiator` instead.
      TEXT
    end

    load_association! :initiator

    # @note Always nil. Use `initiator` instead.
    # @return [nil]
    def user = nil
  end
end
