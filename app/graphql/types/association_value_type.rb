# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType::Association
  class AssociationValueType < Types::BaseObject
    graphql_name "AssociationValue"

    description "A reference to another record, such as the solution's provider."

    field :type_name, String, null: false, description: "The GraphQL type of the referenced record, e.g. `Provider`."

    field :multiple, Boolean, null: false, description: "Whether more than one record can be referenced."
  end
end
