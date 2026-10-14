# frozen_string_literal: true

module Types
  # @see SolutionRevision#provider_state
  class SolutionRevisionProviderStateType < Types::BaseEnum
    description <<~TEXT
    How a `SolutionRevision` changed the solution's provider.
    TEXT

    value "SAME", value: "same" do
      description "The provider did not change."
    end

    value "INITIAL", value: "initial" do
      description "The provider was set for the first time."
    end

    value "DIFF", value: "diff" do
      description "The provider changed."
    end
  end
end
