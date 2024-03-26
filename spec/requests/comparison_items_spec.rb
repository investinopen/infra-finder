# frozen_string_literal: true

RSpec.describe ComparisonItemsController, type: :request do
  include_context "existing comparison"

  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  let(:success_path) { solutions_path }

  describe "POST /solutions/:solution_id/compare" do
    it "can add a solution" do
      expect do
        post solution_compare_path(solution)
      end.to change(ComparisonItem, :count).by(1)

      expect(response).to redirect_to(success_path)
    end

    context "when the solution has already been compared" do
      before do
        current_comparison.add! solution
      end

      it "operates safely" do
        expect do
          post solution_compare_path(solution)
        end.to keep_the_same(ComparisonItem, :count)

        expect(response).to redirect_to(success_path)
      end
    end

    context "when the maximum number of solutions have been added" do
      let_it_be(:existing_solutions) { FactoryBot.create_list :solution, ComparisonItem::MAX_ITEMS }

      before do
        existing_solutions.each do |solution|
          current_comparison.add! solution
        end
      end

      it "refuses to add any more" do
        expect do
          post solution_compare_path(solution)
        end.to keep_the_same(ComparisonItem, :count)

        expect(response).to redirect_to(success_path)
        expect(flash[:alert]).to eq I18n.t("activerecord.errors.models.comparison_item.items_exceeded", count: ComparisonItem::MAX_ITEMS)
      end
    end
  end

  describe "DELETE /solutions/:solution_id/compare" do
    it "is a no-op when the solution isn't currently compared" do
      expect do
        delete solution_compare_path(solution)
      end.to keep_the_same(ComparisonItem, :count)

      expect(response).to redirect_to(success_path)
    end

    context "when the solution has already been compared" do
      before do
        current_comparison.add! solution
      end

      it "uncompares the solution" do
        expect do
          delete solution_compare_path(solution)
        end.to change(ComparisonItem, :count).by(-1)

        expect(response).to redirect_to(success_path)
      end
    end
  end
end
