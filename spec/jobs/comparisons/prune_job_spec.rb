# frozen_string_literal: true

RSpec.describe Comparisons::PruneJob, type: :job do
  let_it_be(:old_comparison, refind: true) { FactoryBot.create :comparison, :prunable }

  it "prunes old comparisons" do
    expect do
      described_class.perform_now
    end.to change(Comparison, :count).by(-1)

    expect do
      old_comparison.reload
    end.to raise_error ActiveRecord::RecordNotFound
  end
end
