# frozen_string_literal: true

module Types
  # @abstract The base edge type used throughout the schema.
  # @see Types::BaseConnection
  class BaseEdge < Types::AbstractObjectType
    # add `node` and `cursor` fields, as well as `node_type(...)` override
    include GraphQL::Types::Relay::EdgeBehaviors

    node_nullable false
  end
end
