# frozen_string_literal: true

RSpec.describe SolutionIntakes::Approve, type: :operation do
  let!(:name) { "Test Solution" }

  let!(:solution_intake) { FactoryBot.create(:solution_intake, name:) }

  context "when in_review" do
    before do
      solution_intake.transition_to! :in_review
    end

    it "creates a new solution and approves the intake" do
      expect do
        solution_intake.approve!
      end.to execute_safely
        .and change(Solution, :count).by(1)
        .and change { solution_intake.reload.state }.from("in_review").to("approved")
        .and change { solution_intake.current_state(force_reload: true) }.from("in_review").to("approved")
    end
  end
end
