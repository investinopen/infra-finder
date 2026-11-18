# frozen_string_literal: true

module Invitations
  # @see Invitation
  # @see InvitationTransition
  class StateMachine
    include Statesman::Machine

    state :pending, initial: true
    state :created
    state :success
    state :failure

    transition from: :pending, to: :failure
    transition from: :pending, to: :created
    transition from: :created, to: :failure
    transition from: :created, to: :success
    transition from: :success, to: :created

    guard_transition(to: :created) do |invitation|
      invitation.valid? :finalize
    end

    after_transition do |invitation, transition|
      invitation.update_column :state, transition.to_state
    end
  end
end
