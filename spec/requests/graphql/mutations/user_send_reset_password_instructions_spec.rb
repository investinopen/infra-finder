# frozen_string_literal: true

RSpec.describe Mutations::UserSendResetPasswordInstructions, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserSendResetPasswordInstructions($input: UserSendResetPasswordInstructionsInput!) {
    userSendResetPasswordInstructions(input: $input) {
      user { email }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:user, refind: true) { FactoryBot.create(:user) }

  let_mutation_input!(:user_id) { user.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:user_send_reset_password_instructions) do |m|
      m.prop :user do |u|
        u[:email] = user.email
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :user_send_reset_password_instructions
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "emails the instructions" do
      expect_request! do |req|
        req.effect! change(ActionMailer::Base.deliveries, :count).by(1)
        req.effect! change { user.reload.reset_password_token }

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(ActionMailer::Base.deliveries, :count)

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_a_super_admin_user do
    include_examples "a successful mutation"
  end

  as_an_admin_user do
    include_examples "a successful mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_a_regular_user do
    include_examples "an unauthorized mutation"

    context "when sending to themselves" do
      let_mutation_input!(:user_id) { regular_user.to_encoded_id }

      it "emails the instructions" do
        expect_request! do |req|
          req.effect! change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
    end
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
