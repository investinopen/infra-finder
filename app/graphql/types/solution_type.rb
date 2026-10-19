# frozen_string_literal: true

module Types
  # @see Solution
  class SolutionType < Types::AbstractModel
    description <<~TEXT
    A solution listed in Infra Finder. Published solutions are public; editors can also read their
    own unpublished ones.
    TEXT

    implements ::Types::CommentableType
    implements ::Types::SolutionInterfaceType

    field :identifier, String, null: false do
      description "A unique, human-readable identifier for the solution."
    end

    field :publication, ::Types::PublicationType, null: true, authorize_field: { to: :show_hidden?, raise: false } do
      description "Whether the solution is published."
    end

    field :published_at, GraphQL::Types::ISO8601DateTime, null: true, authorize_field: { to: :show_hidden?, raise: false } do
      description "When the solution was last published."
    end

    field :claim_state, ::Types::SolutionClaimStateType, null: false do
      description "Whether a provider has claimed the solution."
    end

    field :flags, ::Types::SolutionFlagsType, null: false do
      description "Characteristics derived from the solution's properties."
    end

    field :drafts, resolver: ::Resolvers::SolutionDraftResolver do
      description "The solution's drafts."
    end

    field :revisions, resolver: ::Resolvers::SolutionRevisionResolver do
      description "The history of changes to the solution."
    end

    field :intake, "::Types::SolutionIntakeType", null: true do
      description "The intake the solution was created from, if any."
    end

    expose_authorization_rule :create_draft?, <<~TEXT
    Whether the current user can start a draft of changes to this solution.
    TEXT

    load_association! :solution_intake, as: :intake
  end
end
