# frozen_string_literal: true

RSpec.describe LocationsConfig do
  around do |example|
    original = ENV.fetch("LOCATIONS_ADMIN_SPA", nil)

    ENV["LOCATIONS_ADMIN_SPA"] = admin_spa

    example.run
  ensure
    ENV["LOCATIONS_ADMIN_SPA"] = original
  end

  describe ".admin_spa_origin" do
    context "without an admin SPA" do
      let(:admin_spa) { "" }

      it { expect(described_class.admin_spa_origin).to eq "*" }
    end

    context "with an admin SPA under a path" do
      let(:admin_spa) { "https://example.org/admin" }

      it { expect(described_class.admin_spa_origin).to eq "https://example.org" }
    end

    context "with a non-default port" do
      let(:admin_spa) { "http://localhost:5173" }

      it { expect(described_class.admin_spa_origin).to eq "http://localhost:5173" }
    end
  end
end
