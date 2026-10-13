# frozen_string_literal: true

RSpec.describe Mutations::ViewerSignOut, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ViewerSignOut($input: ViewerSignOutInput!) {
    viewerSignOut(input: $input) {
      signedOut
      ... ErrorFragment
    }
  }
  GRAPHQL

  as_an_admin_user do
    before { token }

    let!(:other_device_token) { token_helper.build_token(from_user: current_user) }

    it "revokes only the token used for the request" do
      expected_shape = gql.mutation(:viewer_sign_out) do |m|
        m[:signed_out] = true
      end

      expect_request! do |req|
        req.effect! change(AllowlistedJwt, :count).by(-1)

        req.data! expected_shape
      end

      post "/graphql", params: { query: "query { viewer { email } }" }.to_json,
        headers: { "CONTENT_TYPE" => "application/json", "AUTHORIZATION" => "Bearer #{token}" }

      expect(response).to have_http_status(:unauthorized)

      make_graphql_request! "query { viewer { email } }", token: other_device_token, operation: nil

      expect(graphql_response(:data, :viewer, :email)).to eq current_user.email
    end
  end

  as_an_anonymous_user do
    it "is not authorized" do
      expect_request! do |req|
        req.unauthorized!

        req.data! gql.empty_mutation(:viewer_sign_out)
      end
    end
  end
end
