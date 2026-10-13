# frozen_string_literal: true

RSpec.describe Mutations::UserConfirm, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserConfirm($input: UserConfirmInput!) {
    userConfirm(input: $input) {
      confirmed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let!(:unconfirmed) { FactoryBot.create :user, :with_admin, confirmed: false }

  let(:raw_token) { unconfirmed.confirmation_token }

  let_mutation_input!(:confirmation_token) { raw_token }

  as_an_anonymous_user do
    it "confirms the user" do
      expected_shape = gql.mutation(:user_confirm) do |m|
        m[:confirmed] = true
      end

      expect_request! do |req|
        req.effect! change { unconfirmed.reload.confirmed? }.from(false).to(true)

        req.data! expected_shape
      end
    end

    context "with an invalid token" do
      let(:raw_token) { "not-a-token" }

      it "fails" do
        expected_shape = gql.mutation(:user_confirm, no_errors: false) do |m|
          m[:confirmed] = be_blank

          m.attribute_errors do |ae|
            ae.error :confirmation_token, /is invalid/
          end
        end

        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end
end
