# frozen_string_literal: true

RSpec.describe Mutations::UserDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserDestroy($input: UserDestroyInput!) {
    userDestroy(input: $input) {
      destroyed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:target_user, refind: true) { FactoryBot.create :user }

  let_mutation_input!(:user_id) { target_user.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :user_destroy }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  as_a_super_admin_user do
    it "destroys the user" do
      expect_request! do |req|
        req.effect! change(User, :count).by(-1)

        req.data! gql.mutation(:user_destroy) { |m| m[:destroyed] = true }
      end
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
