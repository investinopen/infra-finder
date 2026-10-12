# frozen_string_literal: true

RSpec.describe Sessions::PruneJob, type: :job do
  let(:session_class) { ActiveRecord::SessionStore::Session }

  let!(:active_session) { session_class.create!(session_id: SecureRandom.hex, data: {}) }
  let!(:expired_session) { session_class.create!(session_id: SecureRandom.hex, data: {}) }

  before do
    expired_session.update_column(:updated_at, (SessionConfig.ttl + 1).days.ago)
  end

  it "prunes sessions that have not been used within the TTL" do
    expect do
      described_class.perform_now
    end.to change(session_class, :count).by(-1)

    expect(session_class.where(id: active_session.id)).to exist
  end
end
