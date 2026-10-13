# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserUnlock
    class UserUnlock < VOGMutations::Implementation
      include Users::ReportsDeviseErrors

      use_contract! :user_unlock

      # @param [String] unlock_token
      # @return [void]
      def call(unlock_token:)
        user = User.unlock_access_by_token(unlock_token)

        check_devise_errors!(user)

        attach! :unlocked, true
      end
    end
  end
end
