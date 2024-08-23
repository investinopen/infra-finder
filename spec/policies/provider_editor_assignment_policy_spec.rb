# frozen_string_literal: true

RSpec.describe ProviderEditorAssignmentPolicy, type: :policy do
  subject { described_class.new(identity, provider_editor_assignment) }

  let_it_be(:provider_editor_assignment) { FactoryBot.create :provider_editor_assignment }
  let_it_be(:identity) { FactoryBot.create :user }

  context "when the user is an admin" do
    let_it_be(:identity) { FactoryBot.create :user, :with_admin }

    it { is_expected.to permit_actions :new, :create }
  end
end
