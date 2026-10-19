# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionCreate
  class SolutionCreate < Mutations::MutateSolution
    description <<~TEXT
    Create a single `Solution` record.
    TEXT

    performs_operation! "mutations.implementations.solution_create"
  end
end
