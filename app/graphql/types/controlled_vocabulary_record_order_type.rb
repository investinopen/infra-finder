# frozen_string_literal: true

module Types
  # @see Resolvers::ControlledVocabularyRecordResolver
  class ControlledVocabularyRecordOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of controlled vocabulary records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort records by their default order (\"Other\" last, then by name)."
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
  end
end
