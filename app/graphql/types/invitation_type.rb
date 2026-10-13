# frozen_string_literal: true

module Types
  # @see Invitation
  class InvitationType < Types::AbstractModel
    description <<~TEXT
    An invitation that creates an editor account for a provider.
    TEXT

    field :email, String, null: false do
      description "The invited person's email address."
    end

    field :first_name, String, null: false do
      description "The invited person's first name."
    end

    field :last_name, String, null: false do
      description "The invited person's last name."
    end

    field :memo, String, null: true do
      description "An internal note about the invitation."
    end

    field :notification_sent_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When the welcome email was sent."
    end

    field :current_state, ::Types::InvitationStateType, null: false do
      description "The current state of the invitation."
    end

    field :provider, "::Types::ProviderType", null: false do
      description "The provider the invited person will edit for."
    end

    field :admin, "::Types::UserType", null: true do
      description "The admin who sent the invitation."
    end

    field :user, "::Types::UserType", null: true do
      description "The user account created for the invitation."
    end

    field :transitions, resolver: ::Resolvers::InvitationTransitionResolver do
      description "The history of the invitation's state changes."
    end

    load_association! :provider
    load_association! :admin
    load_association! :user
    load_association! :invitation_transitions, as: :transitions_for_state

    load_current_state! from: :transitions_for_state
  end
end
