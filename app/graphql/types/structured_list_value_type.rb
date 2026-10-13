# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::StructuredList
  class StructuredListValueType < Types::BaseObject
    graphql_name "StructuredListValue"

    description "A list of structured entries, such as grants or institutions."

    field :fields, [::Types::StructuredFieldType, { null: false }], null: false, description: "The fields of each entry."

    field :free_input_key, String, null: true, description: "The free-text property for information that does not fit the entries."
  end
end
