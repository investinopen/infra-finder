# frozen_string_literal: true

module Types
  # @see ::SolutionImport
  # @see ::SolutionImportTransition
  # @see ::SolutionImports::StateMachine
  class SolutionImportStateType < Types::BaseEnum
    description <<~TEXT
    The current state of a `SolutionImport`.
    TEXT

    value "PENDING", value: "pending" do
      description <<~TEXT
      The solution import is in the `pending` state.
      TEXT
    end

    value "INVALID", value: "invalid" do
      description <<~TEXT
      The solution import is in the `invalid` state.
      TEXT
    end

    value "STARTED", value: "started" do
      description <<~TEXT
      The solution import is in the `started` state.
      TEXT
    end

    value "SUCCESS", value: "success" do
      description <<~TEXT
      The solution import is in the `success` state.
      TEXT
    end

    value "FAILURE", value: "failure" do
      description <<~TEXT
      The solution import is in the `failure` state.
      TEXT
    end
  end
end
