# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserResendConfirmation
  class UserResendConfirmation < Mutations::BaseMutation
    description <<~TEXT
    Email confirmation instructions again.

    It reports success whether or not the email belongs to an unconfirmed
    account, so it cannot be used to discover which addresses are registered.
    TEXT

    field :requested, Boolean, null: true do
      description "Whether the request was accepted."
    end

    argument :email, String, required: true do
      description "The email address to send instructions to."
    end

    performs_operation! "mutations.implementations.user_resend_confirmation"
  end
end
