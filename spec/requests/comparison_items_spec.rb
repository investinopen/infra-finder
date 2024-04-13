# frozen_string_literal: true

RSpec.describe ComparisonItemsController, type: :request do
  include_context "existing comparison"

  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  let(:success_path) { solutions_path }

  describe "POST /solutions/:solution_id/compare" do
    shared_examples "success" do
      it "can add a solution" do
        expect do
          post solution_compare_path(solution), as: format
        end.to change(ComparisonItem, :count).by(1)

        if format == :turbo_stream
          assert_turbo_stream action: "update", count: 3
        else
          expect(response).to redirect_to(success_path)
        end
      end

      context "when the solution has already been compared" do
        before do
          current_comparison.add! solution
        end

        it "operates safely" do
          expect do
            post solution_compare_path(solution), as: format
          end.to keep_the_same(ComparisonItem, :count)

          if format == :turbo_stream
            assert_turbo_stream action: "update", count: 3
          else
            expect(response).to redirect_to(success_path)
          end
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
            post solution_compare_path(solution), as: format
          end.to keep_the_same(ComparisonItem, :count)

          if format == :turbo_stream
            assert_turbo_stream action: "update", count: 4
            expect(flash.now[:alert]).to eq I18n.t("activerecord.errors.models.comparison_item.items_exceeded", count: ComparisonItem::MAX_ITEMS)
          else
            expect(response).to redirect_to(success_path)
            expect(flash[:alert]).to eq I18n.t("activerecord.errors.models.comparison_item.items_exceeded", count: ComparisonItem::MAX_ITEMS)
          end
        end
      end
    end

    context "as html" do
      let(:format) { nil }

      include_examples "success"
    end

    context "as turbo stream" do
      let(:format) { :turbo_stream }

      include_examples "success"
    end
  end

  describe "DELETE /solutions/:solution_id/compare" do
    let(:referer) do
      solutions_url
    end

    let(:headers) do
      {
        "HTTP_REFERER" => referer,
      }
    end

    shared_examples "success" do
      it "is a no-op when the solution isn't currently compared" do
        expect do
          delete solution_compare_path(solution), headers:, as: format
        end.to keep_the_same(ComparisonItem, :count)

        if format == :turbo_stream
          assert_turbo_stream action: "update", count: 4
        else
          expect(response).to redirect_to(success_path)
        end
      end

      context "when the solution has already been compared" do
        before do
          current_comparison.add! solution
        end

        it "uncompares the solution" do
          expect do
            delete solution_compare_path(solution), headers:, as: format
          end.to change(ComparisonItem, :count).by(-1)

          if format == :turbo_stream
            assert_turbo_stream action: "update", count: 4
          else
            expect(response).to redirect_to(success_path)
          end
        end
      end
    end

    context "as html" do
      let(:format) { nil }

      include_examples "success"
    end

    context "as turbo stream" do
      let(:format) { :turbo_stream }

      include_examples "success"

      context "when requested from a comparison url and there aren't enough items left" do
        before do
          current_comparison.add! solution
        end

        let(:referer) { comparison_url }

        it "renders a special turbo action" do
          expect do
            delete solution_compare_path(solution), headers:, as: format
          end.to change(ComparisonItem, :count).by(-1)

          assert_turbo_stream action: "redirect", target: comparison_url
        end
      end
    end
  end
end
