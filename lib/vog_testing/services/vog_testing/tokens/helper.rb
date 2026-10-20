# frozen_string_literal: true

module VOGTesting
  module Tokens
    # Mint GraphQL API access tokens for request specs.
    #
    # @see Users::Authenticate
    class Helper
      # @param [User] from_user
      # @param [ActiveSupport::TimeWithZone, nil] expires_at defaults to Doorkeeper's access token lifetime
      # @param [Boolean] revoked
      # @param [String] scopes
      # @param [String, nil] session_id join an existing token session
      # @return [String] the plaintext bearer token
      def build_token(from_user:, expires_at: nil, revoked: false, scopes: "openid profile email", session_id: nil)
        build_access_token(from_user:, expires_at:, revoked:, scopes:, session_id:).plaintext_token
      end

      # @see #build_token
      # @return [OAuth::AccessToken]
      def build_access_token(from_user:, expires_at: nil, revoked: false, scopes: "openid profile email", session_id: nil)
        expires_in = expires_at.present? ? (expires_at - Time.current).to_i : Doorkeeper.config.access_token_expires_in.to_i

        OAuth::AccessToken.create!(
          application:,
          resource_owner_id: from_user.id,
          scopes:,
          expires_in:,
          session_id:,
          revoked_at: (Time.current if revoked)
        )
      end

      # @return [OAuth::Application]
      def application
        OAuth::Application.find_or_create_by!(uid: OidcConfig.admin_spa_client_id) do |app|
          app.name = "Admin SPA"
          app.confidential = false
          app.redirect_uri = "http://localhost:5173/"
          app.post_logout_redirect_uri = "http://localhost:5173/"
          app.scopes = "openid profile email"
        end
      end
    end
  end
end
