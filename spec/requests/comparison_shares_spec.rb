# frozen_string_literal: true

RSpec.describe ComparisonSharesController, type: :request do
  let_it_be(:solution_1, refind: true) { FactoryBot.create :solution }
  let_it_be(:solution_2, refind: true) { FactoryBot.create :solution }

  let_it_be(:comparison_share, refind: true) { FactoryBot.create :comparison_share, solution_ids: [solution_1.id, solution_2.id] }

  describe "GET /comparisons/share/:id" do
    include_context "existing comparison"

    context "given an invalid share id" do
      it "redirects" do
        expect do
          get comparison_share_url(SecureRandom.uuid)
        end.to keep_the_same { current_comparison.reload.fingerprint }

        expect(response).to redirect_to solutions_path
      end
    end

    context "when passing ?m=f" do
      it "applies the shared comparison and redirects to solutions index" do
        expect do
          get comparison_share_url(comparison_share, m: ?f)
        end.to change { current_comparison.reload.fingerprint }
          .and change { comparison_share.reload.share_count }.by(1)
          .and change { comparison_share.reload.last_used_at }

        expect(response).to redirect_to solutions_path
      end
    end

    it "renders a comparison" do
      expect do
        get comparison_share_url(comparison_share)
      end.to change { current_comparison.reload.fingerprint }
        .and change { comparison_share.reload.share_count }.by(1)
        .and change { comparison_share.reload.last_used_at }

      expect(response).to have_http_status(:ok)
    end

    context "when the current comparison already matches the shared comparison" do
      before do
        current_comparison.accept_shared!(comparison_share)
      end

      it "renders a comparison" do
        expect do
          get comparison_share_url(comparison_share)
        end.to keep_the_same { current_comparison.reload.fingerprint }
          .and keep_the_same { comparison_share.reload.share_count }
          .and keep_the_same { comparison_share.reload.last_used_at }

        expect(response).to have_http_status(:ok)
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
