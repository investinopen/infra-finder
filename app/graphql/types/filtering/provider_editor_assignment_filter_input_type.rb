# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::ProviderEditorAssignments
    class ProviderEditorAssignmentFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `ProviderEditorAssignment` records.
      TEXT

      inherit_from!(::Filtering::Scopes::ProviderEditorAssignments)

      argument :provider_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::ProviderType, as: :provider, required: false do
        description <<~TEXT
        Filter to assignments for one or more providers.
        TEXT
      end

      argument :user_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::UserType, as: :user, required: false do
        description <<~TEXT
        Filter to assignments for one or more users.
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
