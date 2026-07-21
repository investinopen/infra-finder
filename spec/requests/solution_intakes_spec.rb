# frozen_string_literal: true

RSpec.describe "SolutionIntakes", type: :request do
  let_it_be(:solution_intake, refind: true) { FactoryBot.create(:solution_intake) }

  describe "GET /show" do
    it "can render the show page" do
      get solution_intake_path(solution_intake.slug)

      expect(response).to have_http_status(:success)
    end
  end
end
