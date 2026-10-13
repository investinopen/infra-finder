# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserResetPassword
  class UserResetPassword < Mutations::BaseMutation
    description <<~TEXT
    Set a new password using the token from a password reset or invitation email.

    Every existing token for the user is revoked. If the user may use the API,
    they are signed in and receive a new token.
    TEXT

    field :viewer_token, Types::ViewerTokenType, null: true do
      description "A token for the user, if they may use the API."
    end

    field :user, Types::UserType, null: true do
      description "The user, if they may use the API."
    end

    argument :reset_password_token, String, required: true do
      description "The token from the email."
    end

    argument :password, String, required: true do
      description "The new password."
    end

    argument :password_confirmation, String, required: true do
      description "The new password, again."
    end

    performs_operation! "mutations.implementations.user_reset_password"
  end
end
