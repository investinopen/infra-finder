# frozen_string_literal: true

module Users
  module Tokens
    # Issue a GraphQL API token for a user and add it to the allowlist.
    class Issue
      include Dry::Monads[:result]

      # @param [User] user
      # @return [Dry::Monads::Success(Hash)] `token` and `expires_at`
      def call(user)
        token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

        user.on_jwt_dispatch(token, payload)

        Success(token:, expires_at: Time.zone.at(payload["exp"]))
      end
    end
  end
end
