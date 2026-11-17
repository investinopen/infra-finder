# frozen_string_literal: true

RSpec.describe SessionRecords::PruneJob, type: :job do
  let_it_be(:active_session) { FactoryBot.create(:session_record) }
  let_it_be(:expired_session) { FactoryBot.create(:session_record, :expired) }

  it "prunes sessions that have not been used within the TTL" do
    expect do
      described_class.perform_now
    end.to change(SessionRecord, :count).by(-1)

    expect do
      expired_session.reload
    end.to raise_error(ActiveRecord::RecordNotFound)

    expect do
      active_session.reload
    end.to execute_safely
  end
end
