# frozen_string_literal: true

module Types
  # @see SolutionRevision#kind
  class SolutionRevisionKindType < Types::BaseEnum
    description <<~TEXT
    How a `SolutionRevision` came about.
    TEXT

    value "INITIAL", value: "initial" do
      description "The solution was created."
    end

    value "DIRECT", value: "direct" do
      description "An admin edited the solution directly."
    end

    value "DRAFT", value: "draft" do
      description "An approved draft was applied."
    end

    value "IMPORT", value: "import" do
      description "An import updated the solution."
    end

    value "OTHER", value: "other" do
      description "Any other change."
    end
  end
end
