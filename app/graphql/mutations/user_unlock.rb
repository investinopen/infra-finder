# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserUnlock
  class UserUnlock < Mutations::BaseMutation
    description <<~TEXT
    Unlock an account using the token from an unlock email.
    TEXT

    field :unlocked, Boolean, null: true do
      description "Whether the account was unlocked."
    end

    argument :unlock_token, String, required: true do
      description "The token from the email."
    end

    performs_operation! "mutations.implementations.user_unlock"
  end
end
