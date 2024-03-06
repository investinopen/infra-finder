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
end
