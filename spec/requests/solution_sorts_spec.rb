# frozen_string_literal: true

RSpec.describe SolutionSortsController, type: :request do
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

    it "will update the sort for the current comparison" do
      expect do
        post solution_sort_path, params:
      end.to change { current_comparison.reload.search_filters.s }.to(sort)
    end
  end
end
