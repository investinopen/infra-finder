# frozen_string_literal: true

RSpec.describe "tus uploads", type: :request, graphql: true do
  let(:tus_headers) do
    {
      "Tus-Resumable" => "1.0.0",
      "Upload-Length" => "5",
    }
  end

  after { FileUtils.rm_rf(Rails.root.join("tmp", "tus").glob("*")) }

  def create_upload!(**headers)
    post "/files", headers: tus_headers.merge(headers)
  end

  it "accepts an upload token" do
    session_id = token_helper.build_access_token(from_user: admin_user).session_id

    create_upload! "Upload-Token" => admin_user.upload_token(session_id:)

    expect(response).to have_http_status(:created)
    expect(response.headers["Location"]).to be_present
  end

  it "accepts a GraphQL API bearer token" do
    create_upload! "Authorization" => "Bearer #{token_helper.build_token(from_user: editor_user)}"

    expect(response).to have_http_status(:created)
  end

  context "with an intake upload token" do
    let_it_be(:solution_intake, refind: true) { FactoryBot.create :solution_intake }

    it "accepts it while the intake can be updated" do
      create_upload! "Upload-Token" => solution_intake.upload_token

      expect(response).to have_http_status(:created)
    end

    it "rejects it once the intake is submitted" do
      upload_token = solution_intake.upload_token

      solution_intake.transition_to!(:in_review)

      create_upload! "Upload-Token" => upload_token

      expect(response).to have_http_status(:forbidden)
    end
  end

  it "rejects requests without a token" do
    create_upload!

    expect(response).to have_http_status(:forbidden)
  end

  it "rejects an upload token for another purpose" do
    other_token = Common::Container["tokens.encode"].(sub: admin_user.id, aud: "other", exp: 1.hour.from_now.to_i).value!

    create_upload! "Upload-Token" => other_token

    expect(response).to have_http_status(:forbidden)
  end

  it "rejects users without upload access" do
    create_upload! "Authorization" => "Bearer #{token_helper.build_token(from_user: regular_user)}"

    expect(response).to have_http_status(:forbidden)
  end

  it "lets CORS preflight requests through" do
    options "/files", headers: { "Origin" => "https://admin.example.org", "Access-Control-Request-Method" => "POST" }

    expect(response).to have_http_status(:ok).or have_http_status(:no_content)
  end
end
