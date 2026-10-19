# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::InvitationDestroy
  class InvitationDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `Invitation` record.
    TEXT

    argument :invitation_id, ID, loads: Types::InvitationType, required: true do
      description <<~TEXT
      The invitation to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.invitation_destroy", destroy: true
  end
end
