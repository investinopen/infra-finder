# frozen_string_literal: true

module Types
  # @abstract The base interface type used throughout the schema.
  module BaseInterface
    extend Support::GraphQLAPI::Enhancements::Interface

    edge_type_class Types::BaseEdge
    connection_type_class Types::BaseConnection

    field_class Types::BaseField
  end
end
