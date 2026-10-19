# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::SolutionIntakeCreate
  # @see Mutations::SolutionIntakeUpdate
  class MutateSolutionIntake < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `solutionIntakeCreate` and `solutionIntakeUpdate`.
    TEXT

    field :solution_intake, Types::SolutionIntakeType, null: true do
      description <<~TEXT
      The newly-modified solution intake, if successful.
      TEXT
    end

    shared_argument_set Mutations::Shared::SolutionIntakeAttributes
  end
end
