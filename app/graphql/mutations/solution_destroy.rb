# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionDestroy
  class SolutionDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `Solution` record.
    TEXT

    argument :solution_id, ID, loads: Types::SolutionType, required: true do
      description <<~TEXT
      The solution to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_destroy", destroy: true
  end
end
