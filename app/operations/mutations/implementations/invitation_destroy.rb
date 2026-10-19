# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::InvitationDestroy
    class InvitationDestroy < VOGMutations::Implementation
      use_contract! :invitation_destroy

      authorizes! :invitation, with: :destroy?

      # @param [Invitation] invitation
      # @return [void]
      def call(invitation:)
        destroy_model! invitation, auth: true
      end
    end
  end
end
