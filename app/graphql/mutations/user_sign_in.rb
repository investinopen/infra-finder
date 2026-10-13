# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserSignIn
  class UserSignIn < Mutations::BaseMutation
    description <<~TEXT
    Sign in with an email and password and receive a bearer token for the API.

    Only users with admin or editor access may sign in.
    TEXT

    field :viewer_token, Types::ViewerTokenType, null: true do
      description "The newly issued token."
    end

    field :user, Types::UserType, null: true do
      description "The user who signed in."
    end

    argument :email, String, required: true do
      description "The user's email address."
    end

    argument :password, String, required: true do
      description "The user's password."
    end

    performs_operation! "mutations.implementations.user_sign_in"
  end
end
