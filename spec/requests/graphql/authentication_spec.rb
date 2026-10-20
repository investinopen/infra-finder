# frozen_string_literal: true

RSpec.describe "GraphQL authentication", type: :request, graphql: true do
  let(:query) { "query { viewer { email anonymous } }" }

  def request_with!(authorization)
    headers = { "CONTENT_TYPE" => "application/json" }

    headers["AUTHORIZATION"] = authorization if authorization

    post "/graphql", params: { query: }.to_json, headers:
  end

  def server_message(key) = I18n.t(key, scope: "server_messages.tokens")

  it "treats a request without a token as anonymous" do
    request_with! nil

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.dig("data", "viewer", "anonymous")).to be true
  end

  it "authenticates a valid token" do
    request_with! "Bearer #{token_helper.build_token(from_user: admin_user)}"

    expect(response.parsed_body.dig("data", "viewer", "email")).to eq admin_user.email
  end

  it "rejects an expired token" do
    request_with! "Bearer #{token_helper.build_token(from_user: admin_user, expires_at: 1.minute.ago)}"

    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body).to include_json(errors: [{ message: server_message(:expired) }])
  end

  it "rejects a token whose token session has ended" do
    token = token_helper.build_token(from_user: admin_user)

    OAuth::AccessToken.update_all(session_started_at: (OAuth::AccessToken::SESSION_LIFETIME + 1.day).ago)

    request_with! "Bearer #{token}"

    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body).to include_json(errors: [{ message: server_message(:expired) }])
  end

  it "rejects a revoked token" do
    request_with! "Bearer #{token_helper.build_token(from_user: admin_user, revoked: true)}"

    expect(response).to have_http_status(:unauthorized)
    expect(response.parsed_body).to include_json(errors: [{ message: server_message(:invalid) }])
  end

  it "rejects an unknown token" do
    request_with! "Bearer #{SecureRandom.hex(32)}"

    expect(response).to have_http_status(:unauthorized)
  end

  it "rejects a token without the openid scope" do
    request_with! "Bearer #{token_helper.build_token(from_user: admin_user, scopes: "profile")}"

    expect(response).to have_http_status(:unauthorized)
  end

  it "rejects a malformed authorization header" do
    request_with! "Token abc"

    expect(response).to have_http_status(:unauthorized)
  end

  it "rejects a token for a locked user" do
    token = token_helper.build_token(from_user: admin_user)

    admin_user.lock_access!(send_instructions: false)

    request_with! "Bearer #{token}"

    expect(response).to have_http_status(:forbidden)
    expect(response.parsed_body).to include_json(errors: [{ message: server_message(:inactive) }])
  end

  it "rejects a token for a user without admin or editor access" do
    request_with! "Bearer #{token_helper.build_token(from_user: regular_user)}"

    expect(response).to have_http_status(:forbidden)
  end
end
