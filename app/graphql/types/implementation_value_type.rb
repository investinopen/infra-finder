# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Implementation
  class ImplementationValueType < Types::BaseObject
    graphql_name "ImplementationValue"

    description "How a solution implements a practice: a status plus supporting links."

    field :status_options, [::Types::SolutionPropertyOptionType, { null: false }], null: false, description: "The status choices."

    field :link_mode, ::Types::ImplementationLinkModeType, null: false, description: "How many links it takes."
  end
end
