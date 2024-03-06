# frozen_string_literal: true

RSpec.describe System::PauseJobProcessing, type: :operation do
  it "works" do
    expect_calling.to succeed
  end
end
