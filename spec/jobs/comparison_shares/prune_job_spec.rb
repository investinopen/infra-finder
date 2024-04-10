# frozen_string_literal: true

RSpec.describe ComparisonShares::PruneJob, type: :job do
  let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }

  let_it_be(:shared_comparison_share, refind: true) { FactoryBot.create :comparison_share, :shared }
  let_it_be(:unknown_comparison_share, refind: true) { FactoryBot.create :comparison_share }
  let_it_be(:known_comparison_share, refind: true) do
    FactoryBot.create(:comparison_share).tap do |share|
      comparison.accept_shared!(share)
    end
  end

  it "prunes stale comparison shares" do
    expect do
      described_class.perform_now
    end.to change(ComparisonShare, :count).by(-1)

    aggregate_failures do
      expect do
        unknown_comparison_share.reload
      end.to raise_error ActiveRecord::RecordNotFound

      expect do
        shared_comparison_share.reload
      end.to execute_safely

      expect do
        known_comparison_share.reload
      end.to execute_safely
    end
  end
end
