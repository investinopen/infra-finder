# frozen_string_literal: true

module Types
  # @see Resolvers::ControlledVocabularyRecordResolver
  class ControlledVocabularyRecordOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of controlled vocabulary records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort records with \"Other\" last, then by name (A-Z)."
    end

    value "RECENT" do
      description "Sort records by newest created date."
    end

    value "OLDEST" do
      description "Sort records by oldest created date."
    end

    value "NAME_ASCENDING" do
      description "Sort records by name in ascending (A-Z) order."
    end

    value "NAME_DESCENDING" do
      description "Sort records by name in descending (Z-A) order."
    end

    value "SOLUTIONS_COUNT_ASCENDING" do
      description "Sort records by solutions count in ascending order, with name as a tie-breaker."
    end

    value "SOLUTIONS_COUNT_DESCENDING" do
      description "Sort records by solutions count in descending order, with name as a tie-breaker."
    end

    value "SOLUTION_DRAFTS_COUNT_ASCENDING" do
      description "Sort records by solution drafts count in ascending order, with name as a tie-breaker."
    end

    value "SOLUTION_DRAFTS_COUNT_DESCENDING" do
      description "Sort records by solution drafts count in descending order, with name as a tie-breaker."
    end
  end
end
