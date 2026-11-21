# frozen_string_literal: true

module Types
  # @see Types::ControlledVocabularyExtraFieldType
  class ControlledVocabularyFieldTypeType < Types::BaseEnum
    graphql_name "ControlledVocabularyFieldType"

    description <<~TEXT
    The value type of a controlled vocabulary's extra field.
    TEXT

    value "BOOLEAN", value: "boolean" do
      description "A true/false value."
    end

    value "INTEGER", value: "integer" do
      description "A whole number."
    end

    value "STRING", value: "string" do
      description "Text."
    end
  end
end
