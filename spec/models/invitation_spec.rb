# frozen_string_literal: true

RSpec.describe Invitation, type: :model do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  context "when creating an invitation" do
    let_it_be(:email) { Faker::Internet.email }
    let_it_be(:first_name) { Faker::Name.first_name }
    let_it_be(:last_name) { Faker::Name.last_name }

    let(:attributes) do
      { email:, first_name:, last_name:, provider:, }
    end

    let(:invitation) do
      described_class.new(attributes)
    end

    specify "the invitation automatically creates a user and editor assignment" do
      expect do
        invitation.save!
      end.to execute_safely
        .and change(described_class, :count).by(1)
        .and change(User, :count).by(1)
        .and change(ProviderEditorAssignment, :count).by(1)
        .and have_enqueued_mail(InvitationsMailer, :welcome).once
        .and change { invitation.current_state(force_reload: true) }.from("pending").to("success")
    end

    context "when a user with the specified email already exists" do
      let_it_be(:existing_user, refind: true) { FactoryBot.create(:user, email:) }

      specify "the invitation cannot be created" do
        expect do
          invitation.save!
        end.to execute_safely
          .and keep_the_same(described_class, :count)
          .and keep_the_same(User, :count)
          .and keep_the_same(ProviderEditorAssignment, :count)
          .and have_enqueued_mail(InvitationsMailer, :welcome).exactly(0).times
          .and keep_the_same { invitation.current_state(force_reload: true) }
      end
    end
  end
end
