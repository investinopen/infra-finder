# frozen_string_literal: true

RSpec.describe SolutionsController, type: :request do
  describe "GET /solutions" do
    let_it_be(:solutions) { FactoryBot.create_list :solution, 3, :published }

    it "renders a successful response" do
      get solutions_url

      expect(response).to be_successful
    end
  end

  describe "GET /solutions/:id" do
    let_it_be(:solution) { FactoryBot.create :solution, :published }

    it "renders a successful response" do
      get solution_url(solution)

      expect(response).to be_successful
    end

    context "when the solution is not published" do
      let_it_be(:solution) { FactoryBot.create :solution, :unpublished }

      it "renders a successful response" do
        get solution_url(solution)

        expect(response).to have_http_status :not_found
      end
    end
  end
end
