# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe "#comment_notifications" do
    it_behaves_like "a subscription option", :comment_notifications
  end

  describe "#reminder_notifications" do
    it_behaves_like "a subscription option", :reminder_notifications
  end
end
