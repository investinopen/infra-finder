# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::InvitationCreate
    class InvitationCreate < VOGMutations::Implementation
      use_contract! :invitation_create

      authorizes! :invitation, with: :create?

      # Saving runs the invitation's `after_create` hook, which creates the user and sends the
      # email, adding errors (e.g. for an email already registered) rather than failing the save.
      #
      # @param [Invitation] invitation
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(invitation:, **attrs)
        assign_attributes!(invitation, **attrs)

        persist_model! invitation

        check_model! invitation

        attach! :invitation, invitation
      end

      before_prepare def initialize_invitation!
        args[:invitation] = Invitation.new(admin: current_user)
      end
    end
  end
end
