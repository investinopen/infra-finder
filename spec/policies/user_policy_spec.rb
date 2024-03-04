# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(identity, user) }

  let_it_be(:user) { FactoryBot.create :user }

  let_it_be(:identity) { FactoryBot.create :user }

  context "when the user is a super admin" do
    let_it_be(:identity) { FactoryBot.create :user, :with_super_admin }

    it { is_expected.to permit_actions :show, :index }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_actions :destroy, :destroy_all }
  end

  context "when the user is an admin" do
    let_it_be(:identity) { FactoryBot.create :user, :with_admin }

    it { is_expected.to permit_actions :show, :index }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions :destroy, :destroy_all }
  end

  context "with a user looking at themselves" do
    subject { described_class.new(identity, identity) }

    it { is_expected.to permit_actions :show }
    it { is_expected.to forbid_actions :index }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions :destroy, :destroy_all }
  end

  context "with a regular user" do
    it { is_expected.to forbid_actions :show, :index }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions :destroy, :destroy_all }
  end
end
