# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::SolutionCreate
  # @see Mutations::SolutionUpdate
  class MutateSolution < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `solutionCreate` and `solutionUpdate`.
    TEXT

    field :solution, Types::SolutionType, null: true do
      description <<~TEXT
      The newly-modified solution, if successful.
      TEXT
    end

    shared_argument_set Mutations::Shared::SolutionAttributes
  end
end
