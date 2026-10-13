# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe "#comment_notifications" do
    it_behaves_like "a subscription option", :comment_notifications
  end

  describe "#reminder_notifications" do
    it_behaves_like "a subscription option", :reminder_notifications
  end

  describe "API tokens" do
    let_it_be(:user, refind: true) { FactoryBot.create :user, :with_admin }

    before do
      2.times { Common::Container["users.tokens.issue"].(user) }
    end

    it "revokes them all when the password changes" do
      expect do
        user.update!(password: "a different password", password_confirmation: "a different password")
      end.to change { user.allowlisted_jwts.count }.from(2).to(0)
    end

    it "keeps them when other attributes change" do
      expect do
        user.update!(name: "Renamed")
      end.to keep_the_same { user.allowlisted_jwts.count }
    end
  end
end
