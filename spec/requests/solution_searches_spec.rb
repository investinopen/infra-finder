# frozen_string_literal: true

RSpec.describe SolutionSearchesController, type: :request do
  describe "GET /solution_search" do
    it "redirects to /solutions" do
      expect do
        get solution_search_path
      end.to execute_safely

      expect(response).to redirect_to solutions_path
    end
  end

  describe "POST /solution_search" do
    include_context "existing comparison"

    let(:name_or_provider_name_cont) { "dat" }

    let(:params) do
      {
        q: {
          name_or_provider_name_cont:,
        },
      }
    end

    let(:referer) do
      solutions_url
    end

    let(:headers) do
      {
        "HTTP_REFERER" => referer,
      }
    end

    shared_examples_for "success" do
      it "will update the filters for the current comparison" do
        expect do
          post solution_search_path, headers:, params:, as: format
        end.to change { current_comparison.reload.search_filters.name_or_provider_name_cont }.to("dat")
      end

      context "when requesting from a comparison share url" do
        let(:referer) { comparison_share_url(SecureRandom.uuid) }

        it "will update the filters for the current comparison" do
          expect do
            post solution_search_path, headers:, params:, as: format
          end.to change { current_comparison.reload.search_filters.name_or_provider_name_cont }.to("dat")
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

  describe "DELETE /solution_search" do
    include_context "existing comparison"

    before do
      current_comparison.search_filters = { name_or_provider_name_cont: "dat" }

      current_comparison.save!
    end

    shared_examples_for "success" do
      it "clears the filters" do
        expect do
          delete solution_search_path, as: :format
        end.to change { current_comparison.reload.search_filters.present? }.from(true).to(false)
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
