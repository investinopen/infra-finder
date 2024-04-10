# frozen_string_literal: true

RSpec.describe ProviderPolicy, type: :policy do
  subject { described_class.new(identity, provider) }

  let_it_be(:provider) { FactoryBot.create :provider }

  let_it_be(:identity) { FactoryBot.create :user }

  context "when a regular user" do
    it { is_expected.to forbid_actions(:index, :show) }
  end
end
