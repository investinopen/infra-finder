# frozen_string_literal: true

RSpec.describe Mutations::ViewerRefreshToken, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ViewerRefreshToken($input: ViewerRefreshTokenInput!) {
    viewerRefreshToken(input: $input) {
      viewerToken {
        token
        expiresAt
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  as_an_editor_user do
    before { token }

    it "issues a new token and revokes the old one" do
      expected_shape = gql.mutation(:viewer_refresh_token) do |m|
        m.prop :viewer_token do |vt|
          vt[:token] = be_present
          vt[:expires_at] = be_present
        end
      end

      expect_request! do |req|
        req.effect! keep_the_same(AllowlistedJwt, :count)

        req.data! expected_shape
      end

      new_token = graphql_response(:data, :viewerRefreshToken, :viewerToken, :token)

      expect(new_token).not_to eq token

      make_graphql_request! "query { viewer { email } }", token: new_token, operation: nil

      expect(graphql_response(:data, :viewer, :email)).to eq current_user.email

      post "/graphql", params: { query: "query { viewer { email } }" }.to_json,
        headers: { "CONTENT_TYPE" => "application/json", "AUTHORIZATION" => "Bearer #{token}" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  as_an_anonymous_user do
    it "is not authorized" do
      expect_request! do |req|
        req.unauthorized!

        req.data! gql.empty_mutation(:viewer_refresh_token)
      end
    end
  end
end
