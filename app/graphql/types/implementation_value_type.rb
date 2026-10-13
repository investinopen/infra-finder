# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Implementation
  class ImplementationValueType < Types::BaseObject
    graphql_name "ImplementationValue"
    description "How a solution implements a practice: supporting links and a statement. Its status is a separate property."

    field :link_mode, ::Types::ImplementationLinkModeType, null: false, description: "How many links it takes."

    field :status_property_key, String, null: false, description: "The key of the property holding its status."
  end
end
