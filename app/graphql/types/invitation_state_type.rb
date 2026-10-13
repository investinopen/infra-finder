# frozen_string_literal: true

module Types
  # @see ::Invitation
  # @see ::InvitationTransition
  # @see ::Invitations::StateMachine
  class InvitationStateType < Types::BaseEnum
    description <<~TEXT
    The current state of a `Invitation`.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      The invitation is in the `pending` state.
      TEXT
    end

    value "CREATED", value: "created" do
      description <<~TEXT
      The invitation is in the `created` state.
      TEXT
    end

    value "SUCCESS", value: "success" do
      description <<~TEXT
      The invitation is in the `success` state.
      TEXT
    end

    value "FAILURE", value: "failure" do
      description <<~TEXT
      The invitation is in the `failure` state.
      TEXT
    end
  end
end
