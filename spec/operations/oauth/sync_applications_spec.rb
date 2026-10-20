# frozen_string_literal: true

RSpec.describe OAuth::SyncApplications, type: :operation do
  around do |example|
    original = ENV.fetch("LOCATIONS_ADMIN_SPA", nil)

    ENV["LOCATIONS_ADMIN_SPA"] = admin_spa

    example.run
  ensure
    ENV["LOCATIONS_ADMIN_SPA"] = original
  end

  let(:application) { OAuth::Application.find_by!(uid: OidcConfig.admin_spa_client_id) }

  context "without an admin SPA" do
    let(:admin_spa) { "" }

    it "does nothing" do
      expect_calling.to succeed.with(nil)
    end
  end

  context "with an admin SPA" do
    let(:admin_spa) { "http://localhost:5173" }

    it "creates a public application for it" do
      expect { operation.call }.to change(OAuth::Application, :count).by(1)

      expect(application).to have_attributes(
        confidential: false,
        redirect_uri: "http://localhost:5173/",
        post_logout_redirect_uri: "http://localhost:5173/",
        scopes: Doorkeeper::OAuth::Scopes.from_string("openid profile email")
      )
    end

    it "updates the existing application" do
      operation.call

      ENV["LOCATIONS_ADMIN_SPA"] = "https://admin.example.org"

      expect { operation.call }.to keep_the_same(OAuth::Application, :count)

      expect(application.redirect_uri).to eq "https://admin.example.org/"
    end
  end
end
