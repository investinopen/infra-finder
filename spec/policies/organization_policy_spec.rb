# frozen_string_literal: true

RSpec.describe OrganizationPolicy, type: :policy do
  subject { described_class.new(identity, organization) }

  let_it_be(:organization) { FactoryBot.create :organization }

  let_it_be(:identity) { FactoryBot.create :user }

  context "when a regular user" do
    it { is_expected.to forbid_actions(:index, :show) }
  end
end
