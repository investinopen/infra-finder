# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::Invitations
    class InvitationFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `Invitation` records.
      TEXT

      inherit_from!(::Filtering::Scopes::Invitations)

      argument :provider_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::ProviderType, as: :provider, required: false do
        description <<~TEXT
        Filter to invitations for one or more providers.
        TEXT
      end

      argument :email, ::GraphQL::Types::String, required: false do
        description <<~TEXT
        Look for an exact email match.
        TEXT
      end

      argument :in_state, [::Types::InvitationStateType, { null: false }], required: false do
        description <<~TEXT
        Filter to invitations in one or more states.
        TEXT
      end

      argument :created_at, ::Types::FilterMatchTimeInputType, required: false do
        description <<~TEXT
        Filter the model's `created_at` with time constraints.
        TEXT
      end

      argument :updated_at, ::Types::FilterMatchTimeInputType, required: false do
        description <<~TEXT
        Filter the model's `updated_at` with time constraints.
        TEXT
      end
    end
  end
end
