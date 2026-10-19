# frozen_string_literal: true

RSpec.describe ActiveAdmin::CommentPolicy, type: :policy do
  it "shares the comment rules" do
    expect(described_class).to be < CommentPolicy
  end
end
