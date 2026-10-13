# frozen_string_literal: true

module Users
  module Tokens
    # Remove a single GraphQL API token from the allowlist.
    class Revoke
      include Dry::Monads[:result]

      # @param [User] user
      # @param [Hash] payload the decoded token payload
      # @return [Dry::Monads::Success(User)]
      def call(user, payload)
        User.revoke_jwt(payload, user)

        Success user
      end
    end
  end
end
