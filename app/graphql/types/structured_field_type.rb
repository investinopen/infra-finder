# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::StructuredField
  class StructuredFieldType < Types::BaseObject
    graphql_name "StructuredField"

    description "One field of an entry in a structured list."

    field :name, String, null: false, description: "The field's name on the entry type."

    field :label, String, null: false, description: "A human-readable label."

    field :scalar, ::Types::ScalarKindType, null: false, description: "The kind of value."

    field :required, Boolean, null: false, description: "Whether each entry must have a value."
  end
end
