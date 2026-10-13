# frozen_string_literal: true

module VOGTesting
  module Tokens
    # Mint GraphQL API tokens for request specs.
    #
    # @see Users::Tokens::Issue
    class Helper
      # @param [User] from_user
      # @param [ActiveSupport::TimeWithZone, nil] expires_at defaults to devise-jwt's expiration time
      # @param [Boolean] allowlisted whether to add the token to the allowlist (a token that is not is treated as revoked)
      # @param [Boolean] with_random_secret sign with an unknown secret to produce an invalid token
      # @return [String]
      def build_token(from_user:, expires_at: nil, allowlisted: true, with_random_secret: false)
        payload = { "sub" => from_user.id, "scp" => "user", "aud" => nil }

        payload["exp"] = expires_at.to_i if expires_at.present?

        token = encoder_for(with_random_secret:).call(payload)

        from_user.on_jwt_dispatch(token, payload) if allowlisted

        token
      end

      private

      # @return [Warden::JWTAuth::TokenEncoder]
      def encoder_for(with_random_secret:)
        if with_random_secret
          Warden::JWTAuth::TokenEncoder.new(secret: SecureRandom.hex(64))
        else
          Warden::JWTAuth::TokenEncoder.new
        end
      end
    end
  end
end
