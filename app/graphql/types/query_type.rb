# frozen_string_literal: true

module Types
  # The base type for querying the GraphQL API.
  class QueryType < Types::BaseObject
    description <<~TEXT
    The entry point for retrieving data from within the API.
    TEXT

    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # @!group Query Implementations

    implements Types::QueriesViewer

    # @!endgroup Query Implementations
  end
end
