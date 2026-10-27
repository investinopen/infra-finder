# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::Solutions
    class SolutionFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `Solution` records.
      TEXT

      inherit_from!(::Filtering::Scopes::Solutions)

      argument :name_search, ::Types::SearchQueryInputType, required: false do
        description <<~TEXT
        Perform a full-text search with the provided query.
        TEXT
      end

      argument :editable_by_viewer, ::GraphQL::Types::Boolean, required: false do
        description <<~TEXT
        Filter to the solutions the viewer can edit. Admins can edit every solution.
        TEXT
      end

      argument :publication, [::Types::PublicationType, { null: false }], required: false do
        description <<~TEXT
        Filter to solutions with one or more publication statuses.
        TEXT
      end

      argument :claim_state, [::Types::SolutionClaimStateType, { null: false }], required: false do
        description <<~TEXT
        Filter to solutions in one or more claim states.
        TEXT
      end

      argument :provider_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::ProviderType, as: :provider, required: false do
        description <<~TEXT
        Filter to solutions from one or more providers.
        TEXT
      end

      argument :solution_category_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::SolutionCategoryType, as: :solution_category, required: false do
        description <<~TEXT
        Filter to solutions in one or more solution categories.
        TEXT
      end

      argument :with_pending_drafts, ::GraphQL::Types::Boolean, required: false do
        description <<~TEXT
        Filter to solutions with a pending draft.
        TEXT
      end

      argument :with_reviewable_drafts, ::GraphQL::Types::Boolean, required: false do
        description <<~TEXT
        Filter to solutions with a draft in review.
        TEXT
      end

      argument :empty_properties_count, ::Types::FilterMatchIntegerInputType, required: false do
        description <<~TEXT
        Filter the model's `empty_properties_count` with various integer constraints.
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
