# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolution
  class SolutionOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `Solution` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort solutions by name (A-Z)."
    end

    value "RECENT" do
      description "Sort solutions by newest created date."
    end

    value "OLDEST" do
      description "Sort solutions by oldest created date."
    end

    value "RECENT_UPDATES" do
      description "Sort solutions by most recently updated."
    end

    value "OLDEST_UPDATES" do
      description "Sort solutions by least recently updated."
    end

    value "EMPTY_PROPERTIES_COUNT_DESCENDING" do
      description "Sort solutions by most empty properties first. Solutions not yet counted come last."
    end

    value "EMPTY_PROPERTIES_COUNT_ASCENDING" do
      description "Sort solutions by fewest empty properties first. Solutions not yet counted come last."
    end

    value "ALL_DRAFTS_COUNT_DESCENDING" do
      description "Sort solutions by most drafts first, in any state."
    end

    value "ALL_DRAFTS_COUNT_ASCENDING" do
      description "Sort solutions by fewest drafts first, in any state."
    end

    value "PENDING_AND_IN_REVIEW_DRAFTS_COUNT_DESCENDING" do
      description "Sort solutions by most pending or in-review drafts first."
    end

    value "PENDING_AND_IN_REVIEW_DRAFTS_COUNT_ASCENDING" do
      description "Sort solutions by fewest pending or in-review drafts first."
    end

    value "NAME_ASCENDING" do
      description "Sort solutions by name in ascending (A-Z) order."
    end

    value "NAME_DESCENDING" do
      description "Sort solutions by name in descending (Z-A) order."
    end
  end
end
