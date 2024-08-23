# frozen_string_literal: true

module Invitations
  # Notify the user they have been welcomed into Infra Finder.
  #
  # @note This will create a new reset password token for the given user as well.
  class Notifier < Support::HookBased::Actor
    include AfterCommitEverywhere
    include Dry::Initializer[undefined: false].define -> do
      param :invitation, Types::Invitation
    end

    standard_execution!

    delegate :user, :user_persisted?, to: :invitation

    # The reset password token
    #
    # @return [String]
    attr_reader :token

    # @return [Dry::Monads::Success(Invitation)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield send_message!
      end

      Success invitation
    end

    wrapped_hook! def prepare
      # :nocov:
      return Failure[:must_have_user] unless invitation.user_persisted?
      # :nocov:

      # This is protected for some reason.
      @token = user.__send__(:set_reset_password_token)

      super
    end

    wrapped_hook! def send_message
      after_commit do
        InvitationsMailer.welcome(invitation, token).deliver_later

        invitation.touch(:notification_sent_at)
      end

      super
    end
  end
end
