# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ViewerRefreshToken
  class ViewerRefreshToken < Mutations::BaseMutation
    description <<~TEXT
    Exchange the bearer token used for this request for a new one.

    The old token is revoked.
    TEXT

    field :viewer_token, Types::ViewerTokenType, null: true do
      description "The newly issued token."
    end

    performs_operation! "mutations.implementations.viewer_refresh_token"
  end
end
