# frozen_string_literal: true

RSpec.describe SolutionsController, type: :request do
  describe "GET /solutions" do
    let_it_be(:solutions) { FactoryBot.create_list :solution, 3 }

    it "renders a successful response" do
      get solutions_url

      expect(response).to be_successful
    end
  end

  describe "GET /solutions/:id" do
    let_it_be(:solution) { FactoryBot.create :solution }

    it "renders a successful response" do
      get solution_url(solution)

      expect(response).to be_successful
    end
  end
end
