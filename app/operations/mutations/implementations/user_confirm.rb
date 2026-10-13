# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserConfirm
    class UserConfirm < VOGMutations::Implementation
      include Users::ReportsDeviseErrors

      use_contract! :user_confirm

      # @param [String] confirmation_token
      # @return [void]
      def call(confirmation_token:)
        user = User.confirm_by_token(confirmation_token)

        check_devise_errors!(user)

        attach! :confirmed, true
      end
    end
  end
end
