# frozen_string_literal: true

module Types
  module Filtering
    # @see ::Filtering::Scopes::SolutionDrafts
    class SolutionDraftFilterInputType < ::Types::FilterScopeInputObject
      description <<~TEXT
      Filtering options for `SolutionDraft` records.
      TEXT

      inherit_from!(::Filtering::Scopes::SolutionDrafts)

      argument :in_state, [::Types::SolutionDraftStateType, { null: false }], required: false do
        description <<~TEXT
        Filter to drafts in one or more states.
        TEXT
      end

      argument :solution_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::SolutionType, as: :solution, required: false do
        description <<~TEXT
        Filter to drafts of one or more solutions.
        TEXT
      end

      argument :user_ids, [::GraphQL::Types::ID, { null: false }], loads: ::Types::UserType, as: :user, required: false do
        description <<~TEXT
        Filter to drafts created by one or more users.
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
