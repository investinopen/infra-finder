# frozen_string_literal: true

RSpec.describe SolutionSortsController, type: :request do
  describe "GET /solution_search" do
    it "redirects to /solutions" do
      expect do
        get solution_sort_path
      end.to execute_safely

      expect(response).to redirect_to solutions_path
    end
  end

  describe "POST /solution_sort" do
    include_context "existing comparison"

    let(:sort) { "name asc" }

    let(:params) do
      {
        q: {
          s: sort,
        },
      }
    end

    shared_examples_for "success" do
      it "will update the sort for the current comparison" do
        expect do
          post solution_sort_path, params:, as: format
        end.to change { current_comparison.reload.search_filters.s }.to(sort)
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
end
