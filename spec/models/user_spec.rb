# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe "#comment_notifications" do
    it_behaves_like "a subscription option", :comment_notifications
  end

  describe "#reminder_notifications" do
    it_behaves_like "a subscription option", :reminder_notifications
  end

  describe "token sessions" do
    let_it_be(:user, refind: true) { FactoryBot.create :user, :with_admin }

    let(:token_helper) { VOGTesting::System["tokens.helper"] }

    before do
      2.times { token_helper.build_token(from_user: user) }
    end

    it "revokes them all when the password changes" do
      expect do
        user.update!(password: "a different password", password_confirmation: "a different password")
      end.to change { user.oauth_access_tokens.active.count }.from(2).to(0)
    end

    it "keeps them when other attributes change" do
      expect do
        user.update!(name: "Renamed")
      end.to keep_the_same { user.oauth_access_tokens.active.count }
    end
  end

  describe "#remember_me" do
    it "is always true, so every sign-in is remembered" do
      expect(described_class.new.remember_me).to be true
    end
  end
end
