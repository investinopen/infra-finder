# frozen_string_literal: true

RSpec.describe Mutations::UserCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserCreate($input: UserCreateInput!) {
    userCreate(input: $input) {
      user {
        email
        name
        kind
        commentNotifications
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:new_password) { "a-long-enough-password" }

  let_mutation_input!(:email) { "new-admin@example.com" }
  let_mutation_input!(:name) { "New Admin" }
  let_mutation_input!(:admin) { true }
  let_mutation_input!(:password) { new_password }
  let_mutation_input!(:password_confirmation) { new_password }
  let_mutation_input!(:comment_notifications) { "SUBSCRIBED" }

  let(:empty_mutation_shape) { gql.empty_mutation :user_create }

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
    it "creates the user" do
      expected_shape = gql.mutation(:user_create) do |m|
        m.prop(:user) do |u|
          u[:email] = "new-admin@example.com"
          u[:name] = "New Admin"
          u[:kind] = "ADMIN"
          u[:comment_notifications] = "SUBSCRIBED"
        end
      end

      expect_request! do |req|
        req.effect! change(User, :count).by(1)

        req.data! expected_shape
      end
    end

    context "when the confirmation does not match" do
      let_mutation_input!(:password_confirmation) { "something else" }

      it "fails validation" do
        expected_shape = gql.mutation(:user_create, no_errors: false) do |m|
          m[:user] = be_blank

          m.attribute_errors do |ae|
            ae.error :password_confirmation, :must_match_password
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(User, :count)

          req.data! expected_shape
        end
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
