# frozen_string_literal: true

RSpec.describe OidcConfig do
  describe "#signing_key_pem" do
    it "restores newlines from a single-line value" do
      config = described_class.new(signing_key: "-----BEGIN PRIVATE KEY-----\\nabc\\n-----END PRIVATE KEY-----\\n")

      expect(config.signing_key_pem).to eq "-----BEGIN PRIVATE KEY-----\nabc\n-----END PRIVATE KEY-----\n"
    end

    it "is nil when unset" do
      expect(described_class.new(signing_key: "").signing_key_pem).to be_nil
    end
  end
end
