# frozen_string_literal: true

module Types
  # @see SolutionImport
  class SolutionImportType < Types::AbstractModel
    description <<~TEXT
    A spreadsheet of solutions, providers, or intakes loaded into Infra Finder.
    TEXT

    implements ::Types::CommentableType

    field :identifier, Integer, null: false do
      description "The import's sequential number."
    end

    field :strategy, ::Types::SolutionImportStrategyType, null: false do
      description "The format of the source spreadsheet."
    end

    field :current_state, ::Types::SolutionImportStateType, null: false do
      description "The current state of the import."
    end

    field :started_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When processing started."
    end

    field :success_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When processing succeeded."
    end

    field :failure_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When processing failed."
    end

    field :providers_count, Integer, null: false do
      description "How many providers the import created or updated."
    end

    field :solutions_count, Integer, null: false do
      description "How many solutions the import created or updated."
    end

    field :intakes_count, Integer, null: false do
      description "How many intakes the import created."
    end

    field :messages, [::Types::StoredMessageType, { null: false }], null: false do
      description "The log recorded while processing the import."
    end

    field :user, "::Types::UserType", null: true do
      description "The admin who started the import."
    end

    field :transitions, resolver: ::Resolvers::SolutionImportTransitionResolver do
      description "The history of the import's state changes."
    end

    load_association! :user
    load_association! :solution_import_transitions, as: :transitions_for_state
    load_current_state! from: :transitions_for_state
  end
end
