# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Vocabulary
  class VocabularyValueType < Types::BaseObject
    graphql_name "VocabularyValue"

    description "One or more records from a controlled vocabulary."

    field :vocabulary, ::Types::ControlledVocabularyType, null: false, description: "The vocabulary to choose from.", method: :vocab

    field :multiple, Boolean, null: false, description: "Whether more than one record can be chosen."

    field :other_property_key, String, null: true, description: "The free-text property used when the \"Other\" record is chosen."
  end
end
