# frozen_string_literal: true

module Mutations
  # @abstract
  class SolutionIntakeTransition < Mutations::BaseMutation
    description <<~TEXT
    Move an intake through its review workflow.
    TEXT

    field :solution_intake, Types::SolutionIntakeType, null: true do
      description <<~TEXT
      The intake in its new state, if successful.
      TEXT
    end

    argument :solution_intake_id, ID, loads: Types::SolutionIntakeType, required: true do
      description <<~TEXT
      The solution intake to transition.
      TEXT
    end

    argument :note, String, required: false do
      description <<~TEXT
      A note for the transition, included in its history.
      TEXT
    end
  end
end
