# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserRequestPasswordReset
    class UserRequestPasswordReset < VOGMutations::Implementation
      include Users::AuthMutationHelpers

      use_contract! :user_request_password_reset

      # @param [String] email
      # @return [void]
      def call(email:)
        throttle! :password_reset

        User.find_for_authentication(email:)&.send_reset_password_instructions

        attach! :requested, true
      end
    end
  end
end
