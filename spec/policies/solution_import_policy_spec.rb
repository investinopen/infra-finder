# frozen_string_literal: true

RSpec.describe SolutionImportPolicy, type: :policy do
  subject { described_class.new(identity, solution_import) }

  let_it_be(:solution_import) { FactoryBot.create :solution_import }
  let_it_be(:identity) { regular_user }

  context "when the user is a super admin" do
    let_it_be(:identity) { super_admin }

    it { is_expected.to permit_actions(:index, :show) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_actions(:destroy) }
  end

  context "when the user is an admin" do
    let_it_be(:identity) { admin }

    it { is_expected.to permit_actions(:index, :show) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_actions(:destroy) }
  end

  context "when the user has editor access" do
    let_it_be(:identity) { editor }

    it { is_expected.to forbid_actions(:index, :show) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(:destroy) }
  end

  context "with a regular user" do
    it { is_expected.to forbid_actions(:index, :show) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_actions(:destroy) }
  end
end
