# frozen_string_literal: true

RSpec.describe Solution, type: :model do
  context "when dealing with editor assignments" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    let_it_be(:user, refind: true) { FactoryBot.create :user }

    specify "an editor can be assigned" do
      expect do
        solution.assign_editor!(user)
      end.to change(SolutionEditorAssignment, :count).by(1)
        .and change { user.reload.kind }.from("default").to("editor")
    end

    context "when removing an editor" do
      let_it_be(:assignment, refind: true) { solution.assign_editor!(user) }

      before do
        user.reload
      end

      it "will revert the user when destroying the assignment" do
        expect do
          assignment.destroy!
        end.to change(SolutionEditorAssignment, :count).by(-1)
          .and change { user.reload.kind }.from("editor").to("default")
      end
    end
  end

  context "publication" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    it "changes the published_at timestamp when altering publication" do
      expect do
        solution.published!
      end.to change(solution, :published_at).from(nil).to(a_kind_of(Time))
        .and change(described_class.published, :count).by(1)
        .and change(described_class.unpublished, :count).by(-1)

      expect do
        solution.unpublished!
      end.to change(solution, :published_at).from(a_kind_of(Time)).to(nil)
        .and change(described_class.published, :count).by(-1)
        .and change(described_class.unpublished, :count).by(1)
    end

    context "when a published solution is unpublished" do
      let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }

      let_it_be(:comparison_item, refind: true) { FactoryBot.create(:comparison_item, comparison:, solution:) }

      let_it_be(:comparison_share, refind: true) { comparison.comparison_share }

      before do
        solution.published!
      end

      it "purges any links to comparisons that include the solution" do
        expect do
          solution.unpublished!
        end.to change(ComparisonItem, :count).by(-1)
          .and change(ComparisonShareItem, :count).by(-1)
          .and change { comparison_share.comparison_share_items.count }.by(-1)
      end
    end
  end
end
