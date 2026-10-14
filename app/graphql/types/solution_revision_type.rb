# frozen_string_literal: true

module Types
  # @see SolutionRevision
  class SolutionRevisionType < Types::AbstractModel
    description <<~TEXT
    A recorded change to a `Solution`.
    TEXT

    field :identifier, String, null: true do
      description "A human-readable identifier for the revision."
    end

    field :kind, ::Types::SolutionRevisionKindType, null: false do
      description "How the revision came about."
    end

    field :note, String, null: true do
      description "A note about the revision."
    end

    field :reason, String, null: true do
      description "Why the revision was made."
    end

    field :provider_state, ::Types::SolutionRevisionProviderStateType, null: false do
      description "How the revision changed the solution's provider."
    end

    field :diffs_count, Integer, null: false do
      description "How many properties the revision changed."
    end

    field :diffs, [::Types::SolutionRevisionDiffType, { null: false }], null: false do
      description "The changes to each property."
    end

    field :solution, "::Types::SolutionType", null: true do
      description "The solution that changed."
    end

    field :draft, "::Types::SolutionDraftType", null: true do
      description "The draft whose approval made the revision, if any."
    end

    field :user, "::Types::UserType", null: true do
      description "The user who made the change, if known."
    end

    load_association! :solution
    load_association! :solution_draft, as: :draft
    load_association! :user
  end
end
