# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionsPublish
  class SolutionsPublish < Mutations::BaseMutation
    description <<~TEXT
    Publish several solutions at once. Solutions that are already published are left as they are.
    TEXT

    field :solutions, [Types::SolutionType, { null: false }], null: true do
      description <<~TEXT
      The solutions, if successful.
      TEXT
    end

    argument :solution_ids, [ID, { null: false }], loads: Types::SolutionType, required: true do
      description <<~TEXT
      The solutions to publish.
      TEXT
    end

    performs_operation! "mutations.implementations.solutions_publish"
  end
end
