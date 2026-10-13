# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserConfirm
  class UserConfirm < Mutations::BaseMutation
    description <<~TEXT
    Confirm a user's email address using the token from a confirmation email.
    TEXT

    field :confirmed, Boolean, null: true do
      description "Whether the email address was confirmed."
    end

    argument :confirmation_token, String, required: true do
      description "The token from the email."
    end

    performs_operation! "mutations.implementations.user_confirm"
  end
end
