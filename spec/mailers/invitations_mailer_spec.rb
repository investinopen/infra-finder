# frozen_string_literal: true

RSpec.describe InvitationsMailer, type: :mailer do
  describe "#welcome" do
    let_it_be(:provider) { FactoryBot.create(:provider, name: "Testing Provider") }
    let_it_be(:user) { FactoryBot.create(:user) }
    let_it_be(:invitation) { FactoryBot.create(:invitation, provider:) }
    let_it_be(:token) { Devise.friendly_token }

    let(:mail) { described_class.welcome(invitation, token) }

    it "renders the subject" do
      expect(mail.subject).to be_present
    end

    it "sends to the invitation email" do
      expect(mail.to).to eq([invitation.email])
    end

    it "sends from the default sender" do
      expect(mail.from).to be_present
    end

    it "includes the reset password URL" do
      expect(mail.body.encoded).to include("reset_password_token=#{token}")
    end

    it "includes the provider name" do
      expect(mail.body.encoded).to include(provider.name)
    end

    it "assigns the invitation" do
      expect(mail.body.encoded).to be_present
    end
  end
end
