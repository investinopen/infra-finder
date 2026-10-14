# frozen_string_literal: true

module Types
  # @see ::SolutionIntake
  # @see ::SolutionIntakeTransition
  # @see ::SolutionIntakes::StateMachine
  class SolutionIntakeStateType < Types::BaseEnum
    description <<~TEXT
    The current state of a `SolutionIntake`.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      The solution intake is in the `pending` state.
      TEXT
    end

    value "IN_REVIEW", value: "in_review" do
      description <<~TEXT
      The solution intake is in the `in review` state.
      TEXT
    end

    value "APPROVED", value: "approved" do
      description <<~TEXT
      The solution intake is in the `approved` state.
      TEXT
    end

    value "REJECTED", value: "rejected" do
      description <<~TEXT
      The solution intake is in the `rejected` state.
      TEXT
    end
  end
end
