# frozen_string_literal: true

module Types
  # @abstract The base object type used throughout the schema.
  class BaseObject < Types::AbstractObjectType
    include Support::CallsCommonOperation

    edge_type_class Types::BaseEdge

    connection_type_class Types::BaseConnection

    field_class Types::BaseField
  end
end
