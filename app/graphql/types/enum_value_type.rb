# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Enum
  class EnumValueType < Types::BaseObject
    graphql_name "EnumValue"

    description "One value from a fixed list of options."

    field :options, [::Types::SolutionPropertyOptionType, { null: false }], null: false, description: "The choices."
  end
end
