# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::Users
    class UserFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `User` records.
      TEXT

      inherit_from!(::Filtering::Scopes::Users)

      argument :email, ::GraphQL::Types::String, required: false do
        description <<~TEXT
        Look for an exact email match.
        TEXT
      end

      argument :name_search, ::Types::SearchQueryInputType, required: false do
        description <<~TEXT
        Perform a full-text search with the provided query.
        TEXT
      end

      argument :kind, [::Types::UserKindType, { null: false }], required: false do
        description <<~TEXT
        Filter to users of one or more kinds.
        TEXT
      end

      argument :current_sign_in_at, ::Types::FilterMatchTimeInputType, required: false do
        description <<~TEXT
        Filter the model's `current_sign_in_at` with time constraints.
        TEXT
      end

      argument :sign_in_count, ::Types::FilterMatchIntegerInputType, required: false do
        description <<~TEXT
        Filter the model's `sign_in_count` with various integer constraints.
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
