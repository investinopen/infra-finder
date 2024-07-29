# frozen_string_literal: true

RSpec.describe System::InitialSeed, type: :operation do
  stub_operation! "controlled_vocabularies.upsert_all_records", as: :upsert_all_records, auto_succeed: true

  it "seeds all options" do
    expect_calling.to succeed

    expect(upsert_all_records).to have_received(:call).once
  end
end
