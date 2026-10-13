# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Scalar
  class ScalarValueType < Types::BaseObject
    graphql_name "ScalarValue"

    description "A single value."

    field :scalar, ::Types::ScalarKindType, null: false, description: "The kind of value."

    field :max_length, Integer, null: true, description: "The maximum length of a text value, if any."
  end
end
