# frozen_string_literal: true

RSpec.describe Mutations::Implementations::UserSignIn do
  describe "#check_password" do
    let(:implementation) { described_class.allocate }

    it "hashes the password once for an unknown email, so timing does not reveal accounts" do
      allow(BCrypt::Password).to receive(:create).and_call_original

      expect(implementation.__send__(:check_password, nil, "anything")).to be false

      expect(BCrypt::Password).to have_received(:create).once
    end
  end
end
