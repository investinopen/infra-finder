# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::Providers
    class ProviderFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `Provider` records.
      TEXT

      inherit_from!(::Filtering::Scopes::Providers)

      argument :name_search, ::Types::SearchQueryInputType, required: false do
        description <<~TEXT
        Perform a full-text search with the provided query.
        TEXT
      end

      argument :with_multiple_solutions, ::GraphQL::Types::Boolean, required: false do
        description <<~TEXT
        Filter to only providers with more than one solution.
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
