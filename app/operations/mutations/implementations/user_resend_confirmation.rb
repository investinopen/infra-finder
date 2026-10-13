# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserResendConfirmation
    class UserResendConfirmation < VOGMutations::Implementation
      include Users::AuthMutationHelpers

      use_contract! :user_resend_confirmation

      # @param [String] email
      # @return [void]
      def call(email:)
        throttle! :confirmation

        user = User.find_for_authentication(email:)

        user.send_confirmation_instructions if user.present? && !user.confirmed?

        attach! :requested, true
      end
    end
  end
end
