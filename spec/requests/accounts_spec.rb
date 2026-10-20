# frozen_string_literal: true

RSpec.describe "Account pages", type: :request, default_auth: true do
  # The session cookie is scoped to the issuer's host.
  before { host! URI(LocationsConfig.root).authority }

  def sign_in_with!(user, password: "123456")
    post user_session_path, params: { user: { email: user.email, password: } }
  end

  it "renders the sign-in page in its own layout" do
    get new_user_session_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("accounts").and include(user_session_path)
  end

  it "redirects the old ActiveAdmin sign-in page" do
    get "/admin/login"

    expect(response).to redirect_to("/sign-in")
  end

  it "sends users to sign in for ActiveAdmin, then back" do
    get "/admin"

    expect(response).to redirect_to(new_user_session_url)

    sign_in_with! admin

    expect(response).to redirect_to("#{LocationsConfig.root}/admin")
  end

  it "remembers every sign-in" do
    sign_in_with! admin

    expect(cookies["remember_user_token"]).to be_present
  end

  it "sends admins to the SPA without a stored location, when one is configured" do
    allow(LocationsConfig).to receive_messages(admin_spa?: true, admin_spa: "http://localhost:5173/")

    sign_in_with! admin

    expect(response).to redirect_to("http://localhost:5173/")
  end

  it "sends users without admin or editor access to the public site" do
    sign_in_with! regular_user

    expect(response).to redirect_to(root_url)
  end

  it "rate limits sign-in attempts" do
    11.times { sign_in_with! admin, password: "wrong" }

    expect(response).to redirect_to(new_user_session_url)
    expect(flash[:alert]).to eq I18n.t("devise.failure.rate_limited")
  end
end
