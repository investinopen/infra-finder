# frozen_string_literal: true

# Infra Finder is the OpenID Provider for the admin SPA, a public client using
# the authorization code flow with PKCE.
Doorkeeper.configure do
  orm :active_record

  access_grant_class "OAuth::AccessGrant"
  access_token_class "OAuth::AccessToken"
  application_class "OAuth::Application"

  # Runs in the controller. Users without a sign-in session are sent to sign in
  # and returned here afterwards. This redirects instead of calling
  # `authenticate_user!`, so that doorkeeper-openid_connect can answer
  # `prompt=none` with `login_required`. That answer replaces the redirect, so
  # the location is not stored for it, or a later sign-in would return here.
  resource_owner_authenticator do
    current_user || begin
      store_location_for(:user, request.fullpath) unless params[:prompt].to_s.split.include?("none")

      redirect_to new_user_session_url

      nil
    end
  end

  grant_flows %w[authorization_code]

  force_pkce

  pkce_code_challenge_methods %w[S256]

  authorization_code_expires_in 5.minutes

  access_token_expires_in 1.hour

  use_refresh_token

  hash_token_secrets

  # Copied from the refresh token onto each new access token.
  # @see OAuth::AccessToken
  custom_access_token_attributes %i[session_id session_started_at]

  default_scopes :openid
  optional_scopes :profile, :email
  enforce_configured_scopes

  # Every application is first-party, so there is no consent screen.
  skip_authorization { true }

  force_ssl_in_redirect_uri { |uri| !uri.host.in?(%w[localhost 127.0.0.1]) }
end
