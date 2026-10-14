# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::SolutionImports
    class SolutionImportFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `SolutionImport` records.
      TEXT

      inherit_from!(::Filtering::Scopes::SolutionImports)

      argument :in_state, [::Types::SolutionImportStateType, { null: false }], required: false do
        description <<~TEXT
        Filter to imports in one or more states.
        TEXT
      end

      argument :strategy, [::Types::SolutionImportStrategyType, { null: false }], required: false do
        description <<~TEXT
        Filter to imports using one or more strategies.
        TEXT
      end

      argument :user_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::UserType, as: :user, required: false do
        description <<~TEXT
        Filter to imports started by one or more users.
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
