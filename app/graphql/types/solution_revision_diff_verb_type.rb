# frozen_string_literal: true

module Types
  # @see Solutions::Revisions::Diffs::BaseDiff#verb
  class SolutionRevisionDiffVerbType < Types::BaseEnum
    description <<~TEXT
    What a `SolutionRevisionDiff` did to a value.
    TEXT

    value "CHANGE", value: "change" do
      description "The value changed."
    end

    value "SET", value: "set" do
      description "A value was set where there was none."
    end

    value "UNSET", value: "unset" do
      description "The value was removed."
    end
  end
end
