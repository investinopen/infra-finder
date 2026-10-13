# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserRequestPasswordReset
  class UserRequestPasswordReset < Mutations::BaseMutation
    description <<~TEXT
    Email password reset instructions to a user.

    It reports success whether or not the email belongs to an account, so it
    cannot be used to discover which addresses are registered.
    TEXT

    field :requested, Boolean, null: true do
      description "Whether the request was accepted."
    end

    argument :email, String, required: true do
      description "The email address to send instructions to."
    end

    performs_operation! "mutations.implementations.user_request_password_reset"
  end
end
