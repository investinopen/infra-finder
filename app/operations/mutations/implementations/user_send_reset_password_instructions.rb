# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserSendResetPasswordInstructions
    class UserSendResetPasswordInstructions < VOGMutations::Implementation
      use_contract! :user_send_reset_password_instructions

      authorizes! :user, with: :send_reset_password_instructions?

      # @param [User] user
      # @return [void]
      def call(user:)
        user.send_reset_password_instructions

        attach! :user, user
      end
    end
  end
end
