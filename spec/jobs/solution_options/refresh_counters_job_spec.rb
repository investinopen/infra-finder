# frozen_string_literal: true

RSpec.describe SolutionOptions::RefreshCountersJob, type: :job do
  let_it_be(:board_structure, refind: true) { FactoryBot.create :board_structure }
  let_it_be(:solution_category, refind: true) { FactoryBot.create :solution_category }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, board_structure:, solution_categories: [solution_category] }

  it "will update counters correctly" do
    expect do
      described_class.perform_now
    end.to change { board_structure.reload.solutions_count }.by(1)
      .and change { solution_category.reload.solutions_count }.by(1)
  end
end
