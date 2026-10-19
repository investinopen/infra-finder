# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::SolutionIntakeUpdate
  class SolutionIntakeUpdate < Mutations::MutateSolutionIntake
    description <<~TEXT
    Update a single `SolutionIntake` record.
    TEXT

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to update.
      TEXT
    end

    performs_operation! "mutations.implementations.solution_intake_update"
  end
end
