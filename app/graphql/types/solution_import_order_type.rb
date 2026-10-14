# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolutionImport
  class SolutionImportOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `SolutionImport` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort imports with the most recently created first."
    end

    value "RECENT" do
      description "Sort imports by newest created date."
    end

    value "OLDEST" do
      description "Sort imports by oldest created date."
    end
  end
end
