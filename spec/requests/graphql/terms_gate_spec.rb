# frozen_string_literal: true

RSpec.describe "GraphQL terms and conditions gate", type: :request, graphql: true do
  let_it_be(:pending_editor, refind: true) do
    FactoryBot.create(:user, name: "Pending Editor") do |user|
      FactoryBot.create(:provider).assign_editor!(user)
    end
  end

  let(:current_user) { pending_editor }

  context "when querying the viewer" do
    let(:query) { "query { viewer { email } }" }

    it "is allowed" do
      make_default_request!

      expect(graphql_response(:data, :viewer, :email)).to eq pending_editor.email
    end
  end

  context "when querying anything else" do
    let(:query) { "query($id: ID!) { node(id: $id) { id } }" }

    let(:graphql_variables) { { id: pending_editor.to_encoded_id } }

    it "is refused until the terms are accepted" do
      make_default_request!(no_top_level_errors: false)

      expect(graphql_response(:errors)).to include_json([{ extensions: { code: "TERMS_NOT_ACCEPTED" } }])
    end
  end

  context "when calling a mutation other than the session ones" do
    let(:query) do
      <<~GRAPHQL
      mutation {
        userRequestPasswordReset(input: { email: "someone@example.com" }) {
          requested
        }
      }
      GRAPHQL
    end

    it "is refused before anything runs" do
      expect do
        make_default_request!(no_top_level_errors: false)
      end.to keep_the_same(ActionMailer::Base.deliveries, :count)

      expect(graphql_response(:data)).to be_blank
      expect(graphql_response(:errors)).to include_json([{ extensions: { code: "TERMS_NOT_ACCEPTED" } }])
    end
  end
end
