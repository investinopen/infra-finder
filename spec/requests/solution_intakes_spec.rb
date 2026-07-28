# frozen_string_literal: true

RSpec.describe "SolutionIntakes", type: :request do
  let_it_be(:solution_intake, refind: true) { FactoryBot.create(:solution_intake) }

  describe "GET /show" do
    it "can render the show page" do
      get solution_intake_path(solution_intake.slug)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    let(:turbo_headers) { { "Accept" => "#{Mime[:turbo_stream]}, text/html" } }

    it "answers a draft save with a stream instead of a redirect" do
      patch solution_intake_path(solution_intake.slug),
        params: { skip_validations: "true", solution_intake: { first_name: "Ada" } },
        headers: turbo_headers

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq(Mime[:turbo_stream].to_s)
      expect(response.body).to include("flash-messages")
    end

    it "persists an incomplete draft" do
      patch solution_intake_path(solution_intake.slug),
        params: { skip_validations: "true", solution_intake: { first_name: "Ada", email: "" } },
        headers: turbo_headers

      expect(solution_intake.reload.first_name).to eq("Ada")
    end
  end
end
