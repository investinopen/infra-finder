# frozen_string_literal: true

module Invitations
  # Create an associated {User} for an {Invitation} and assign it as an
  # {ProviderEditorAssignment editor} for the associated {Provider}.
  class UserCreator < Support::HookBased::Actor
    include MonadicTransitions
    include Dry::Initializer[undefined: false].define -> do
      param :invitation, Types::Invitation
    end

    standard_execution!

    delegate :provider, to: :invitation

    # The user created within this service.
    #
    # @return [User]
    attr_reader :user

    # @return [Dry::Monads::Success(Invitation)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield create_user!

        yield assign_provider!

        yield mark_created!
      end

      Success invitation
    end

    wrapped_hook! def prepare
      return Failure[:must_be_pending] unless invitation.in_state?(:pending)

      @user = User.new(invitation.to_user_attributes)

      super
    end

    wrapped_hook! def create_user
      user.password = user.password_confirmation = Devise.friendly_token(36)

      user.skip_confirmation!

      unless user.save
        if user.errors.any? { _1.attribute == :email && _1.type == :taken }
          return Failure[:email_already_registered]
        else
          # :nocov:
          reason = user.errors.full_messages.to_sentence

          return Failure[:user_creation_failed, reason]
          # :nocov:
        end
      end

      invitation.user = user

      invitation.save!(validate: false)

      super
    end

    wrapped_hook! def assign_provider
      provider.assign_editor! user

      super
    end

    wrapped_hook! def mark_created
      yield monadic_transition(invitation, :created)

      super
    end
  end
end
