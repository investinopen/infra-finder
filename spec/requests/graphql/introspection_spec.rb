# frozen_string_literal: true

RSpec.describe "GraphQL Introspection", type: :request do
  let(:query) { File.read(File.join(__dir__, "introspection.graphql")) }

  it "can introspect anonymously without issue" do
    post "/graphql", params: { query: }, as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).not_to have_key("errors")
    expect(response.parsed_body.dig("data", "__schema", "queryType", "name")).to eq "Query"
  end
end
