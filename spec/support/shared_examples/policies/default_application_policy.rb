# frozen_string_literal: true

RSpec.shared_examples_for "default application policy examples" do
  context "as an anonymous user" do
    let(:user) { anonymous_user }

    it { is_expected.to permit_actions(%i[read show]) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action :override }
  end

  context "as a regular user" do
    let(:user) { regular_user }

    it { is_expected.to permit_actions(%i[read show]) }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action(:destroy) }
    it { is_expected.to forbid_action :override }
  end

  context "as an admin / floor user" do
    let(:user) { admin_user }

    it { is_expected.to permit_actions(%i[read show]) }
    it { is_expected.to permit_new_and_create_actions }
    it { is_expected.to permit_edit_and_update_actions }
    it { is_expected.to permit_action :destroy }
    it { is_expected.to permit_action :override }
  end
end
