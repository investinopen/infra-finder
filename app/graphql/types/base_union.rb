# frozen_string_literal: true

module Types
  # @abstract The base union type used throughout the schema.
  #   For caching reasons, we largely avoid using unions,
  #   preferring interfaces instead, but this is here for completeness.
  class BaseUnion < GraphQL::Schema::Union
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
  end
end
