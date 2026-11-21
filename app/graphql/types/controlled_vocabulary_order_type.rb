# frozen_string_literal: true

module Types
  class ControlledVocabularyOrderType < Types::BaseEnum
    description <<~TEXT
    Order the controlled vocabularies by the specified criteria.
    TEXT

    value "NAME_ASCENDING", value: "name_ascending" do
      description <<~TEXT
      TEXT
    end

    value "NAME_DESCENDING", value: "name_descending" do
      description <<~TEXT
      TEXT
    end

    value "RECORDS_COUNT_ASCENDING", value: "records_count_ascending" do
      description <<~TEXT
      TEXT
    end

    value "RECORDS_COUNT_DESCENDING", value: "records_count_descending" do
      description <<~TEXT
      TEXT
    end
  end
end
