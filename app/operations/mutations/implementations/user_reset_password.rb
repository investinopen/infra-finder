# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserResetPassword
    class UserResetPassword < VOGMutations::Implementation
      include Users::AuthMutationHelpers
      include Users::ReportsDeviseErrors

      include Common::Deps[
        issue_token: "users.tokens.issue",
      ]

      use_contract! :user_reset_password

      # @param [String] reset_password_token
      # @param [String] password
      # @param [String] password_confirmation
      # @return [void]
      def call(reset_password_token:, password:, password_confirmation:)
        user = User.reset_password_by_token(reset_password_token:, password:, password_confirmation:)

        check_devise_errors!(user)

        # Matches Devise::PasswordsController: a reset by email also unlocks the account.
        user.unlock_access! if user.access_locked? && user.unlock_strategy_enabled?(:email)

        return unless Users::Access.allowed?(user)

        viewer_token = check_result!(issue_token.(user))

        act_as!(user)

        attach! :viewer_token, viewer_token
        attach! :user, user
      end
    end
  end
end
