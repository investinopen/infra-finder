# frozen_string_literal: true

RSpec.describe Mutations::ViewerAcceptTerms, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ViewerAcceptTerms($input: ViewerAcceptTermsInput!) {
    viewerAcceptTerms(input: $input) {
      user {
        id
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:pending_editor, refind: true) do
    FactoryBot.create(:user, name: "Pending Editor") do |user|
      FactoryBot.create(:provider).assign_editor!(user)
    end
  end

  let(:accepting) { true }

  let_mutation_input!(:accept_terms_and_conditions) { accepting }

  context "as an editor who has not accepted the terms" do
    let(:current_user) { pending_editor }

    it "accepts the terms" do
      expected_shape = gql.mutation(:viewer_accept_terms) do |m|
        m.prop :user do |u|
          u[:id] = pending_editor.to_encoded_id
        end
      end

      expect_request! do |req|
        req.effect! change { pending_editor.reload.accepted_terms? }.from(false).to(true)

        req.data! expected_shape
      end
    end

    context "when not accepting" do
      let(:accepting) { false }

      it "fails validation" do
        expected_shape = gql.mutation(:viewer_accept_terms, no_errors: false) do |m|
          m[:user] = be_blank

          m.attribute_errors do |ae|
            ae.error :accept_terms_and_conditions, :must_be_accepted
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { pending_editor.reload.accepted_terms? }

          req.data! expected_shape
        end
      end
    end
  end

  as_an_anonymous_user do
    it "is not authorized" do
      expect_request! do |req|
        req.unauthorized!

        req.data! gql.empty_mutation(:viewer_accept_terms)
      end
    end
  end
end
