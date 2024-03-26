# frozen_string_literal: true

RSpec.describe Users::Create, type: :operation do
  it "can create a user" do
    expect do
      expect_calling_with("test@example.com", "Test User").to succeed.with(a_kind_of(User))
    end.to change(User, :count).by(1)
  end
end
