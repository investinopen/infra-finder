# frozen_string_literal: true

RSpec.describe SolutionDraftPolicy, type: :policy do
  subject { described_class.new(identity, solution_draft) }

  let_it_be(:solution) { FactoryBot.create :solution }

  let_it_be(:solution_draft) { solution.create_draft! }

  let_it_be(:identity) { FactoryBot.create :user }

  context "when the user is an admin" do
    let_it_be(:identity) { FactoryBot.create :user, :with_admin }

    it { is_expected.to permit_action :request_review }
    it { is_expected.to permit_action :request_revision }
    it { is_expected.to permit_action :approve }
    it { is_expected.to permit_action :reject }
  end

  context "when the user has editor access to the solution" do
    before do
      solution.assign_editor!(identity)
    end

    it { is_expected.to permit_action :request_review }
    it { is_expected.not_to permit_action :request_revision }
    it { is_expected.not_to permit_action :approve }
    it { is_expected.not_to permit_action :reject }
  end

  context "with a regular user" do
    it { is_expected.not_to permit_action :request_review }
    it { is_expected.not_to permit_action :request_revision }
    it { is_expected.not_to permit_action :approve }
    it { is_expected.not_to permit_action :reject }
  end
end
