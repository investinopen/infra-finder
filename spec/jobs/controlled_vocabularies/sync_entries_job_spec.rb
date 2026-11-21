# frozen_string_literal: true

RSpec.describe ControlledVocabularies::SyncEntriesJob, type: :job do
  before do
    ControlledVocabularyEntry.delete_all
  end

  it "synchronizes controlled vocabulary entries idempotently" do
    expect do
      described_class.perform_now
    end.to execute_safely
      .and change(ControlledVocabularyEntry, :count).by(ControlledVocabulary.count)

    expect do
      described_class.perform_now
    end.to execute_safely
      .and keep_the_same(ControlledVocabularyEntry, :count)
  end
end
