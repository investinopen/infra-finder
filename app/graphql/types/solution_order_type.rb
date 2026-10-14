# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolution
  class SolutionOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `Solution` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort solutions by name."
    end

    value "RECENT" do
      description "Sort solutions by newest created date."
    end

    value "OLDEST" do
      description "Sort solutions by oldest created date."
    end

    value "NAME_ASCENDING" do
      description "Sort solutions by name in ascending (A-Z) order."
    end

    value "NAME_DESCENDING" do
      description "Sort solutions by name in descending (Z-A) order."
    end
  end
end
