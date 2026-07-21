# frozen_string_literal: true

RSpec.describe SolutionIntakes::Assign, type: :operation do
  let!(:name) { "Test Solution" }

  let!(:solution_intake) { FactoryBot.create(:solution_intake, name:) }

  context "when there is no existing solution" do
    it "creates a new solution" do
      expect do
        solution_intake.assign!
      end.to execute_safely
        .and change(Solution, :count).by(1)
    end
  end

  context "when there is an assigned solution" do
    let(:old_name) { "Old Solution" }

    let!(:solution) { FactoryBot.create(:solution, name: old_name) }

    before do
      solution_intake.update!(solution:)
    end

    it "updates the existing solution" do
      expect do
        solution_intake.assign!
      end.to execute_safely
        .and keep_the_same(Solution, :count)
        .and change { solution.reload.name }.from(old_name).to(name)
    end
  end
end
