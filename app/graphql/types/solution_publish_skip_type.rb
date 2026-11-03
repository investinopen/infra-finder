# frozen_string_literal: true

module Types
  # @see Mutations::SolutionsPublish
  class SolutionPublishSkipType < Types::BaseObject
    description <<~TEXT
    A solution that `solutionsPublish` left unpublished, and why.
    TEXT

    field :solution, ::Types::SolutionType, null: false do
      description <<~TEXT
      The solution that was not published.
      TEXT
    end

    field :errors, [::Types::MutationAttributeErrorType, { null: false }], null: false do
      description <<~TEXT
      What kept it from being published: a missing required property or an invalid value,
      named by the input field that sets it (for example, `solutionCategoryIds`).
      TEXT
    end
  end
end
