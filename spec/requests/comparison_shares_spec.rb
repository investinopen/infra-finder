# frozen_string_literal: true

RSpec.describe ComparisonSharesController, type: :request do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  let_it_be(:comparison_share, refind: true) { FactoryBot.create :comparison_share, solution_ids: [solution.id] }

  describe "GET /comparisons/share/:id" do
    include_context "existing comparison"

    it "applies the shared comparison and redirects to solutions index" do
      expect do
        get comparison_share_url(comparison_share)
      end.to change { current_comparison.reload.fingerprint }
        .and change { comparison_share.reload.share_count }.by(1)
        .and change { comparison_share.reload.last_used_at }

      expect(response).to redirect_to solutions_path
    end

    context "when passing ?m=c" do
      it "redirects to the comparison page" do
        expect do
          get comparison_share_url(comparison_share, m: ?c)
        end.to change { current_comparison.reload.fingerprint }
          .and change { comparison_share.reload.share_count }.by(1)
          .and change { comparison_share.reload.last_used_at }

        expect(response).to redirect_to comparison_path
      end
    end
  end

  describe "PUT /comparisons/share/:id/shared" do
    include_context "existing comparison"

    it "marks the shared comparison as having been shared" do
      expect do
        put shared_comparison_share_url(comparison_share)
      end.to change { comparison_share.reload.shared_at }
        .and change { comparison_share.reload.last_used_at }

      expect(response).to have_http_status :no_content
    end
  end
end
