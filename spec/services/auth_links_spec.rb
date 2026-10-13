# frozen_string_literal: true

RSpec.describe AuthLinks do
  let(:devise_url) { "http://localhost:6856/users/password/edit?reset_password_token=abc" }

  context "without an admin SPA configured" do
    it "uses the Devise URL" do
      expect(described_class.reset_password("abc") { devise_url }).to eq devise_url
    end
  end

  context "with an admin SPA configured" do
    around do |example|
      ENV["LOCATIONS_ADMIN_SPA"] = "https://admin.example.org"

      example.run
    ensure
      ENV.delete("LOCATIONS_ADMIN_SPA")
    end

    it "links to the SPA reset page" do
      expect(described_class.reset_password("abc") { devise_url }).to eq "https://admin.example.org/reset-password?token=abc"
    end

    it "links to the SPA confirmation page" do
      expect(described_class.confirmation("abc") { devise_url }).to eq "https://admin.example.org/confirm?token=abc"
    end

    it "links to the SPA unlock page" do
      expect(described_class.unlock("abc") { devise_url }).to eq "https://admin.example.org/unlock?token=abc"
    end
  end

  context "with an admin SPA under a path" do
    around do |example|
      ENV["LOCATIONS_ADMIN_SPA"] = "https://example.org/admin"

      example.run
    ensure
      ENV.delete("LOCATIONS_ADMIN_SPA")
    end

    it "keeps the path" do
      expect(described_class.confirmation("abc") { "unused" }).to eq "https://example.org/admin/confirm?token=abc"
    end
  end
end
