# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::SolutionIntakes
    class SolutionIntakeFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `SolutionIntake` records.
      TEXT

      inherit_from!(::Filtering::Scopes::SolutionIntakes)

      argument :name_search, ::Types::SearchQueryInputType, required: false do
        description <<~TEXT
        Perform a full-text search with the provided query.
        TEXT
      end

      argument :in_state, [::Types::SolutionIntakeStateType, { null: false }], required: false do
        description <<~TEXT
        Filter to intakes in one or more states.
        TEXT
      end

      argument :provider_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::ProviderType, as: :provider, required: false do
        description <<~TEXT
        Filter to intakes for one or more providers.
        TEXT
      end

      argument :missing_provider, ::GraphQL::Types::Boolean, required: false do
        description <<~TEXT
        Filter to intakes that have no provider yet.
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
