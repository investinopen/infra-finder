# frozen_string_literal: true

module Types
  # The base type for defining mutations.
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the API.
    TEXT

    field :error_test, mutation: Mutations::ErrorTest

    field :user_confirm, mutation: Mutations::UserConfirm

    field :user_request_password_reset, mutation: Mutations::UserRequestPasswordReset

    field :user_resend_confirmation, mutation: Mutations::UserResendConfirmation

    field :user_reset_password, mutation: Mutations::UserResetPassword

    field :user_sign_in, mutation: Mutations::UserSignIn

    field :user_unlock, mutation: Mutations::UserUnlock

    field :viewer_accept_terms, mutation: Mutations::ViewerAcceptTerms, terms_exempt: true

    field :viewer_refresh_token, mutation: Mutations::ViewerRefreshToken, terms_exempt: true

    field :viewer_sign_out, mutation: Mutations::ViewerSignOut, terms_exempt: true
  end
end
