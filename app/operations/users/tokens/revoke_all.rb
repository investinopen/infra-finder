# frozen_string_literal: true

module Users
  module Tokens
    # Remove every GraphQL API token a user holds from the allowlist.
    class RevokeAll
      include Dry::Monads[:result]

      # @param [User] user
      # @return [Dry::Monads::Success(User)]
      def call(user)
        user.allowlisted_jwts.delete_all

        Success user
      end
    end
  end
end
