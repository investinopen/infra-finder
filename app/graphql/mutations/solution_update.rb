# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionUpdate
  class SolutionUpdate < Mutations::MutateSolution
    description <<~TEXT
    Update a single `Solution` record.
    TEXT

    argument :solution_id, ID, loads: Types::SolutionType, required: true do
      description <<~TEXT
      The solution to update.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_update"
  end
end
