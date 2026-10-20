# frozen_string_literal: true

RSpec.describe "OpenID Provider", type: :request, default_auth: true do
  let_it_be(:application) do
    OAuth::Application.create!(
      name: "Admin SPA",
      uid: "test-spa",
      confidential: false,
      redirect_uri: "http://localhost:5173/",
      post_logout_redirect_uri: "http://localhost:5173/",
      scopes: "openid profile email"
    )
  end

  let(:redirect_uri) { "http://localhost:5173/" }

  # The session cookie is scoped to the issuer's host.
  before { host! URI(LocationsConfig.root).authority }

  let(:code_verifier) { SecureRandom.urlsafe_base64(48) }

  let(:code_challenge) { Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier), padding: false) }

  def authorize!(**params)
    get "/oauth/authorize", params: {
      client_id: application.uid,
      redirect_uri:,
      response_type: "code",
      scope: "openid profile email",
      state: "the-state",
      nonce: "the-nonce",
      code_challenge:,
      code_challenge_method: "S256",
      **params,
    }
  end

  def redirect_params
    Rack::Utils.parse_query(URI(response.location).query)
  end

  def exchange!(code)
    post "/oauth/token", params: {
      grant_type: "authorization_code",
      client_id: application.uid,
      redirect_uri:,
      code:,
      code_verifier:,
    }

    response.parsed_body
  end

  def refresh!(refresh_token)
    post "/oauth/token", params: { grant_type: "refresh_token", client_id: application.uid, refresh_token: }

    response.parsed_body
  end

  # Sign in, authorize, and exchange the code, as the SPA does on each page load.
  def tokens_for!(user)
    sign_in user

    authorize!

    exchange!(redirect_params.fetch("code"))
  end

  def decode_id_token(id_token)
    JWT.decode(
      id_token, Doorkeeper::OpenidConnect.signing_key.verify_key, true,
      algorithm: "RS256", aud: application.uid, verify_aud: true, iss: LocationsConfig.root, verify_iss: true
    ).first
  end

  def viewer_email_with(access_token)
    post "/graphql", params: { query: "query { viewer { email } }" }.to_json,
      headers: { "CONTENT_TYPE" => "application/json", "AUTHORIZATION" => "Bearer #{access_token}" }

    response.parsed_body.dig("data", "viewer", "email")
  end

  describe "discovery" do
    it "describes the provider" do
      get "/.well-known/openid-configuration"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "issuer" => LocationsConfig.root,
        "authorization_endpoint" => "#{LocationsConfig.root}/oauth/authorize",
        "token_endpoint" => "#{LocationsConfig.root}/oauth/token",
        "end_session_endpoint" => "#{LocationsConfig.root}/oauth/logout",
        "jwks_uri" => "#{LocationsConfig.root}/oauth/discovery/keys"
      )
    end

    it "publishes the signing key" do
      get "/oauth/discovery/keys"

      expect(response.parsed_body["keys"]).to contain_exactly(include("kty" => "RSA", "alg" => "RS256", "use" => "sig"))
    end
  end

  describe "the authorization code flow" do
    it "issues tokens that authenticate with the API" do
      tokens = tokens_for!(admin)

      expect(tokens).to include("access_token", "refresh_token", "id_token", "token_type" => "Bearer", "expires_in" => 1.hour.to_i)
      expect(decode_id_token(tokens["id_token"])).to include(
        "sub" => admin.id, "email" => admin.email, "email_verified" => true, "nonce" => "the-nonce"
      )
      expect(viewer_email_with(tokens["access_token"])).to eq admin.email
    end

    it "returns the state with the code" do
      sign_in admin

      authorize!

      expect(response.location).to start_with(redirect_uri)
      expect(redirect_params).to include("code", "state" => "the-state")
    end

    it "requires PKCE" do
      sign_in admin

      authorize!(code_challenge: nil, code_challenge_method: nil)

      expect(response.location.to_s).not_to include("code=")
    end

    it "rejects the wrong code verifier" do
      sign_in admin

      authorize!

      post "/oauth/token", params: {
        grant_type: "authorization_code", client_id: application.uid, redirect_uri:,
        code: redirect_params.fetch("code"), code_verifier: SecureRandom.urlsafe_base64(48),
      }

      expect(response).to have_http_status(:bad_request)
    end

    it "ignores a session_id sent by the client" do
      sign_in admin

      authorize!(session_id: "00000000-0000-0000-0000-000000000000")

      exchange!(redirect_params.fetch("code"))

      expect(OAuth::AccessToken.last.session_id).not_to eq "00000000-0000-0000-0000-000000000000"
    end

    it "sends users without a sign-in session to sign in, then back" do
      authorize!

      expect(response).to redirect_to(new_user_session_url)

      post user_session_path, params: { user: { email: admin.email, password: "123456" } }

      expect(response.location).to start_with("#{LocationsConfig.root}/oauth/authorize")
    end

    it "answers prompt=none without a sign-in session with login_required" do
      authorize!(prompt: "none")

      expect(response.location).to start_with(redirect_uri)
      expect(redirect_params).to include("error" => "login_required", "state" => "the-state")
    end

    it "does not return to a failed prompt=none request after a later sign-in" do
      authorize!(prompt: "none")

      post user_session_path, params: { user: { email: admin.email, password: "123456" } }

      expect(response).to redirect_to("#{LocationsConfig.root}/admin")
    end

    it "keeps token sessions when prompt=login asks for the password again" do
      tokens = tokens_for!(admin)

      authorize!(prompt: "login")

      expect(response).to redirect_to(new_user_session_url)
      expect(viewer_email_with(tokens["access_token"])).to eq admin.email
    end

    it "issues a code for prompt=none with a sign-in session" do
      sign_in admin

      authorize!(prompt: "none")

      expect(redirect_params).to include("code")
    end

    it "sends users without admin or editor access back with access_denied" do
      sign_in regular_user

      authorize!

      expect(response.location).to start_with(redirect_uri)
      expect(redirect_params).to include("error" => "access_denied", "state" => "the-state")
    end
  end

  describe "refreshing" do
    it "continues the token session" do
      tokens = tokens_for!(admin)

      session_id = OAuth::AccessToken.by_token(tokens["access_token"]).session_id

      refreshed = refresh!(tokens["refresh_token"])

      expect(response).to have_http_status(:ok)
      expect(OAuth::AccessToken.by_token(refreshed["access_token"]).session_id).to eq session_id
    end

    it "fails once the token session has passed its lifetime" do
      tokens = tokens_for!(admin)

      OAuth::AccessToken.update_all(session_started_at: (OAuth::AccessToken::SESSION_LIFETIME + 1.day).ago)

      refresh!(tokens["refresh_token"])

      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body).to include("error" => "invalid_grant")
    end
  end

  describe "signing out" do
    it "ends the sign-in session and every token session, then returns to the client" do
      tokens = tokens_for!(admin)

      other_device = VOGTesting::System["tokens.helper"].build_token(from_user: admin)

      get "/oauth/logout", params: { id_token_hint: tokens["id_token"], post_logout_redirect_uri: redirect_uri, state: "bye" }

      expect(response).to redirect_to("#{redirect_uri}?state=bye")
      expect(viewer_email_with(tokens["access_token"])).to be_nil
      expect(viewer_email_with(other_device)).to be_nil

      authorize!

      expect(response).to redirect_to(new_user_session_url)
    end

    it "sends the user to sign in for an unregistered post-logout URI" do
      tokens = tokens_for!(admin)

      get "/oauth/logout", params: { id_token_hint: tokens["id_token"], post_logout_redirect_uri: "https://example.com/" }

      expect(response).to redirect_to(new_user_session_url)
    end

    it "requires a valid id_token_hint" do
      sign_in admin

      get "/oauth/logout", params: { id_token_hint: "nope", post_logout_redirect_uri: redirect_uri }

      expect(response).to have_http_status(:bad_request)

      authorize!

      expect(redirect_params).to include("code")
    end

    it "revokes every token session when signing out of the account pages" do
      tokens = tokens_for!(admin)

      delete destroy_user_session_path

      expect(viewer_email_with(tokens["access_token"])).to be_nil
    end
  end
end
