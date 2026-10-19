# frozen_string_literal: true

RSpec.describe Mutations::UserUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserUpdate($input: UserUpdateInput!) {
    userUpdate(input: $input) {
      user {
        email
        unconfirmedEmail
        name
        kind
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:target_user, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { FactoryBot.create(:provider).assign_editor!(_1) } }

  let_mutation_input!(:user_id) { target_user.to_encoded_id }
  let_mutation_input!(:name) { "Renamed" }
  let_mutation_input!(:super_admin) { true }

  let(:empty_mutation_shape) { gql.empty_mutation :user_update }

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
    it "updates the user" do
      expected_shape = gql.mutation(:user_update) do |m|
        m.prop(:user) do |u|
          u[:email] = target_user.email
          u[:unconfirmed_email] = nil
          u[:name] = "Renamed"
          u[:kind] = "SUPER_ADMIN"
        end
      end

      expect_request! do |req|
        req.effect! change { target_user.reload.kind }.to("super_admin")

        req.data! expected_shape
      end
    end

    context "when changing the password" do
      let_mutation_input!(:password) { "a-new-long-password" }
      let_mutation_input!(:password_confirmation) { "a-new-long-password" }

      it "changes it" do
        expect_request! do |req|
          req.effect! change { target_user.reload.valid_password?("a-new-long-password") }.from(false).to(true)
        end
      end

      context "without a confirmation" do
        clear_mutation_input!(:password_confirmation)

        it "fails validation" do
          expected_shape = gql.mutation(:user_update, no_errors: false) do |m|
            m[:user] = be_blank

            m.attribute_errors do |ae|
              ae.error :password_confirmation, :must_match_password
            end
          end

          expect_request! do |req|
            req.effect! keep_the_same { target_user.reload.encrypted_password }

            req.data! expected_shape
          end
        end
      end
    end

    context "when changing the email" do
      let_mutation_input!(:email) { "changed@example.com" }

      it "waits for the user to confirm it" do
        expected_shape = gql.mutation(:user_update) do |m|
          m.prop(:user) do |u|
            u[:email] = target_user.email
            u[:unconfirmed_email] = "changed@example.com"
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { target_user.reload.email }

          req.data! expected_shape
        end
      end
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end

  context "as the user themselves" do
    let(:current_user) { target_user }

    include_examples "an unauthorized mutation"
  end
end
