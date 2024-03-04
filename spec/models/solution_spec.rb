# frozen_string_literal: true

RSpec.describe Solution, type: :model do
  context "when adding an editor" do
    let_it_be(:solution) { FactoryBot.create :solution }

    let_it_be(:user) { FactoryBot.create :user }

    it "adds a record and updates the user's kind" do
      expect do
        solution.assign_editor!(user)
      end.to change(SolutionEditorAssignment, :count).by(1)
        .and change { user.reload.kind }.from("default").to("editor")
    end
  end
end
