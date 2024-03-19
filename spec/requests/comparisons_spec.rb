# frozen_string_literal: true

RSpec.describe ComparisonsController do
  describe "GET /comparison" do
    context "when there is no current comparison" do
      it "redirects to solutions" do
        expect do
          get comparison_url
        end.to execute_safely

        expect(response).to redirect_to solutions_path
      end
    end

    context "with a current comparison" do
      include_context "existing comparison"

      context "with no items" do
        it "redirects to solutions" do
          expect do
            get comparison_url
          end.to execute_safely

          expect(response).to redirect_to solutions_path
        end
      end

      context "with at least 2 items" do
        let_it_be(:solutions, refind: true) { FactoryBot.create_list :solution, 2 }

        before do
          solutions.each do |solution|
            current_comparison.add!(solution)
          end
        end

        it "renders the solution" do
          expect do
            get comparison_url
          end.to execute_safely

          expect(response).to be_successful
        end
      end
    end
  end

  context "DELETE /comparison" do
    context "when there is no current comparison" do
      it "redirects to solutions" do
        expect do
          delete comparison_url
        end.to execute_safely

        expect(response).to redirect_to solutions_path
      end
    end

    context "with a current comparison" do
      include_context "existing comparison"

      let_it_be(:solutions, refind: true) { FactoryBot.create_list :solution, 2 }

      before do
        solutions.each do |solution|
          current_comparison.add!(solution)
        end
      end

      it "clears the items" do
        expect do
          delete comparison_url
        end.to change(ComparisonItem, :count).by(-2)
          .and keep_the_same(Comparison, :count)

        expect(response).to redirect_to(solutions_path)
      end
    end
  end
end
