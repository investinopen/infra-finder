# frozen_string_literal: true

RSpec.describe SolutionDrafts::Approve, type: :operation do
  let_it_be(:editor, refind: true) { FactoryBot.create :user }
  let_it_be(:admin, refind: true) { FactoryBot.create :user, :with_admin }

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:solution_props) do
    {
      provider:,
      name: "Test Solution",
      founded_on: Date.new(2020, 1, 1),
    }
  end

  let_it_be(:solution, refind: true) do
    FactoryBot.create(:solution, editors: [editor], **complete_solution_attributes(:actual), **solution_props)
  end

  let_it_be(:solution_draft, refind: true) do
    solution.create_draft!(user: editor).tap do |draft|
      draft.name = "Test Solution Update"
      draft.founded_on = Date.new(2021, 1, 1)
      draft.save!
    end
  end

  before do
    solution.create_revision!
  end

  context "when in the wrong state" do
    it "does not work" do
      expect do
        expect_calling_with(solution_draft, user: admin, memo: "A test memo").to monad_fail.with_key(:invalid_transition)
      end.to keep_the_same(ActiveSnapshot::Snapshot, :count)
        .and keep_the_same(SolutionRevision, :count)
    end
  end

  context "when in the right state" do
    before do
      solution_draft.request_review!
    end

    it "approves the solution and creates a revision" do
      expect do
        expect_calling_with(solution_draft, user: admin, memo: "A test memo").to succeed
      end.to change(ActiveSnapshot::Snapshot, :count).by(1)
        .and change(SolutionRevision, :count).by(1)
        .and change { solution.reload.publication }.from("unpublished").to("published")
    end

    context "with another open draft" do
      let!(:other_draft) do
        solution.create_draft!(user: admin).tap do |draft|
          draft.update!(founded_on: Date.new(2022, 1, 1))
        end
      end

      it "copies the approved changes into properties the other draft has not overridden" do
        perform_enqueued_jobs(only: SolutionDrafts::UpdateFromSolutionJob) do
          expect_calling_with(solution_draft, user: admin).to succeed
        end

        expect(other_draft.reload).to have_attributes(
          name: "Test Solution Update",
          founded_on: Date.new(2022, 1, 1),
          draft_overrides: ["founded_on"]
        )
      end
    end
  end
end
