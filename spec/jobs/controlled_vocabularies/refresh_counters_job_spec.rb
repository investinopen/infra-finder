# frozen_string_literal: true

RSpec.describe ControlledVocabularies::RefreshCountersJob, type: :job do
  let_it_be(:hosting_strategy, refind: true) { FactoryBot.create :hosting_strategy }
  let_it_be(:solution_category, refind: true) { FactoryBot.create :solution_category }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, hosting_strategy:, solution_categories: [solution_category] }

  it "will update counters correctly" do
    expect do
      described_class.perform_now
    end.to change { hosting_strategy.reload.solutions_count }.by(1)
      .and change { solution_category.reload.solutions_count }.by(1)
  end
end
