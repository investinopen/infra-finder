# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionsUnpublish
  class SolutionsUnpublish < Mutations::BaseMutation
    description <<~TEXT
    Unpublish several solutions at once. Solutions that are already unpublished are left as they are.
    TEXT

    field :solutions, [Types::SolutionType, { null: false }], null: true do
      description <<~TEXT
      The solutions, if successful.
      TEXT
    end

    argument :solution_ids, [ID, { null: false }], loads: Types::SolutionType, required: true do
      description <<~TEXT
      The solutions to unpublish.
      TEXT
    end

    performs_operation! "mutations.implementations.solutions_unpublish"
  end
end
