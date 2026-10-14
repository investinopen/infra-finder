# frozen_string_literal: true

module Types
  # @see SolutionImport#strategy
  class SolutionImportStrategyType < Types::BaseEnum
    description <<~TEXT
    The format of a `SolutionImport` source.
    TEXT

    value "LEGACY", value: "legacy" do
      description "The legacy spreadsheet format."
    end

    value "EOI", value: "eoi" do
      description "The expression of interest format."
    end

    value "INTAKE", value: "intake" do
      description "The intake format, which creates solution intakes."
    end

    value "V2", value: "v2" do
      description "The current spreadsheet format."
    end
  end
end
