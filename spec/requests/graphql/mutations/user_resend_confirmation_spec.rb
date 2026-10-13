# frozen_string_literal: true

RSpec.describe Mutations::UserResendConfirmation, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserResendConfirmation($input: UserResendConfirmationInput!) {
    userResendConfirmation(input: $input) {
      requested
      ... ErrorFragment
    }
  }
  GRAPHQL

  let!(:unconfirmed) { FactoryBot.create :user, :with_admin, confirmed: false }

  let(:target_email) { unconfirmed.email }

  let_mutation_input!(:email) { target_email }

  let(:valid_mutation_shape) do
    gql.mutation(:user_resend_confirmation) do |m|
      m[:requested] = true
    end
  end

  as_an_anonymous_user do
    it "emails confirmation instructions" do
      expect_request! do |req|
        req.effect! change(ActionMailer::Base.deliveries, :count).by(1)

        req.data! valid_mutation_shape
      end
    end

    context "with an already confirmed email" do
      let(:target_email) { admin_user.email }

      it "reports success without sending anything" do
        expect_request! do |req|
          req.effect! keep_the_same(ActionMailer::Base.deliveries, :count)

          req.data! valid_mutation_shape
        end
      end
    end
  end
end
