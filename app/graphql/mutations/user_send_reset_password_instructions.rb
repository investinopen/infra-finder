# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserSendResetPasswordInstructions
  class UserSendResetPasswordInstructions < Mutations::BaseMutation
    description <<~TEXT
    Email a user the instructions for resetting their password.
    TEXT

    field :user, Types::UserType, null: true do
      description "The user the instructions were sent to."
    end

    argument :user_id, ID, loads: Types::UserType, required: true do
      description <<~TEXT
      The user to send the instructions to.
      TEXT
    end

    performs_operation! "mutations.implementations.user_send_reset_password_instructions"
  end
end
