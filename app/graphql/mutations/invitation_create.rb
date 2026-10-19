# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::InvitationCreate
  class InvitationCreate < Mutations::BaseMutation
    description <<~TEXT
    Invite someone to become an editor of a provider's solutions. This creates their user account
    and emails them.
    TEXT

    field :invitation, Types::InvitationType, null: true do
      description <<~TEXT
      The new invitation, if successful.
      TEXT
    end

    argument :provider_id, ID, loads: Types::ProviderType, required: true do
      description "The provider whose solutions the invited user will edit."
    end

    argument :email, String, required: true do
      description "The email address to invite."
    end

    argument :first_name, String, required: true do
      description "The invitee's first name."
    end

    argument :last_name, String, required: true do
      description "The invitee's last name."
    end

    performs_operation! "mutations.implementations.invitation_create"
  end
end
