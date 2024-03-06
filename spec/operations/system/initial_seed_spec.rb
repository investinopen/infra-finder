# frozen_string_literal: true

RSpec.describe System::InitialSeed, type: :operation do
  stub_operation! "seeding.seed_all_options", as: :seed_all_options, auto_succeed: true

  it "seeds all options" do
    expect_calling.to succeed

    expect(seed_all_options).to have_received(:call).once
  end
end
