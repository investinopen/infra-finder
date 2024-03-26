# frozen_string_literal: true

RSpec.describe Comparisons::Fetch, type: :operation do
  let(:actual_session_id) { SecureRandom.hex(16) }

  let(:session_id) { actual_session_id }

  let(:ip) { "127.0.0.1" }

  it "finds or creates a comparison" do
    expect do
      expect_calling_with(session_id:, ip:).to succeed.with a_kind_of(Comparison)
    end.to change(Comparison, :count).by(1)
  end

  context "with a rack session id" do
    let(:session_id) { Rack::Session::SessionId.new(actual_session_id) }

    it "finds or creates a comparison" do
      expect do
        expect_calling_with(session_id:, ip:).to succeed.with a_kind_of(Comparison)
      end.to change(Comparison, :count).by(1)
    end
  end
end
