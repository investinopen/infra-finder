# frozen_string_literal: true

module Types
  # A GraphQL API token issued to the viewer.
  #
  # @see Users::Tokens::Issue
  class ViewerTokenType < Types::BaseObject
    description <<~TEXT
    A bearer token for the GraphQL API. Send it as `Authorization: Bearer <token>`.
    TEXT

    field :token, String, null: false do
      description "The bearer token."
    end

    field :expires_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the token expires. Use `viewerRefreshToken` before then to keep the session."
    end
  end
end
