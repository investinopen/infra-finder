# frozen_string_literal: true

module Invitations
  # This wraps the {Invitations::UserCreator} and {Invitations::Notifier} services
  # as part of an `after_create` callback on the {Invitation} model. It is used to
  # ensure that errors are set for the ActiveAdmin form and to prevent a record
  # from being persisted needlessly.
  class Finalizer < Support::HookBased::Actor
    include MonadicTransitions
    include Dry::Initializer[undefined: false].define -> do
      param :invitation, Types::Invitation
    end

    standard_execution!

    # @return [Dry::Monads::Success(Invitation)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield create_associated_user!

        yield send_notification!

        yield mark_success!
      end

      Success invitation
    end

    wrapped_hook! def prepare
      return Failure[:must_be_pending] unless invitation.in_state?(:pending)

      super
    end

    wrapped_hook! def create_associated_user
      yield invitation.create_associated_user

      super
    end

    wrapped_hook! def send_notification
      yield invitation.notify

      super
    end

    # @note an invitation as a success will trigger a notification.
    wrapped_hook! def mark_success
      yield monadic_transition(invitation, :success)

      super
    end
  end
end
