# frozen_string_literal: true

RSpec.describe ComparisonShare, type: :model do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  let_it_be(:comparison_share, refind: true) { FactoryBot.create :comparison_share, solution_ids: [solution.id] }

  describe "#shared!" do
    it "idempotently sets the shared_at and last_used_at timestamps" do
      expect do
        comparison_share.shared!
      end.to change(comparison_share, :last_used_at).from(nil).to(a_kind_of(Time))
        .and change(comparison_share, :shared_at).from(nil).to(a_kind_of(Time))

      expect do
        comparison_share.shared!
      end.to keep_the_same { comparison_share.last_used_at }
        .and keep_the_same { comparison_share.shared_at }
    end
  end

  describe "#used!" do
    it "tracks share count and usage" do
      expect do
        comparison_share.used!
      end.to change(comparison_share, :last_used_at)
        .and change(comparison_share, :share_count).by(1)
    end
  end
end
