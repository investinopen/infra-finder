# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::TryInviting
  class InvitationAttempter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :intake, Types::Intake

      option :memo, Types::String, default: proc { DEFAULT_MEMO }
    end

    DEFAULT_MEMO = "Created via solution intake approval."

    standard_execution!

    delegate :provider, :email, :first_name, :last_name, to: :intake

    # @return [Invitation, nil]
    attr_reader :invitation

    # @return [Boolean]
    attr_reader :invited

    # @return [String]
    attr_reader :memo

    # @return [Dry::Monads::Success(Boolean)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield attempt_inviting!
      end

      Success invited
    end

    wrapped_hook! def prepare
      @invitation = nil
      @invited = false

      super
    end

    wrapped_hook! def attempt_inviting
      @invitation = call_operation("invitations.attempt",
        provider:,
        email:,
        first_name:,
        last_name:,
        memo:
      ).value_or(nil)

      intake.update_column(:editor_id, invitation&.user_id)

      @invited = invitation.present? && invitation.in_state?(:success)

      super
    end
  end
end
