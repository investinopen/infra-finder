# frozen_string_literal: true

module Types
  # @abstract The base connection type used throughout the schema.
  # @see Types::BaseEdge
  class BaseConnection < Types::AbstractObjectType
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors

    implements Types::PaginatedType

    # Override built-in pageInfo field type with our type, supporting page-based pagination
    get_field("pageInfo").type = GraphQL::Schema::Member::BuildType.parse_type(Types::PageInfoType, null: false)

    edge_nullable false
    node_nullable false
    edges_nullable false
  end
end
