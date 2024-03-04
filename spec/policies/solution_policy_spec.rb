# frozen_string_literal: true

RSpec.describe SolutionPolicy, type: :policy do
  subject { described_class.new(identity, solution) }

  let_it_be(:solution) { FactoryBot.create :solution }
  let_it_be(:identity) { FactoryBot.create :user }

  context "when the user is an admin" do
    let_it_be(:identity) { FactoryBot.create :user, :with_admin }

    it { is_expected.to permit_action :create_draft }
  end

  context "when the user has editor access to the solution" do
    before do
      solution.assign_editor!(identity)
    end

    it { is_expected.to permit_action :create_draft }
  end

  context "with a regular user" do
    it { is_expected.not_to permit_action :create_draft }
  end
end
