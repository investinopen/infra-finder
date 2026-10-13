# frozen_string_literal: true

RSpec.describe Mutations::UserResetPassword, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserResetPassword($input: UserResetPasswordInput!) {
    userResetPassword(input: $input) {
      viewerToken {
        token
      }
      user {
        id
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:resetting) { editor_user }

  let(:raw_token) { resetting.__send__(:set_reset_password_token) }

  let(:new_password) { "a brand new password" }

  let(:confirmation) { new_password }

  let_mutation_input!(:reset_password_token) { raw_token }
  let_mutation_input!(:password) { new_password }
  let_mutation_input!(:password_confirmation) { confirmation }

  as_an_anonymous_user do
    before { token_helper.build_token(from_user: resetting) }

    it "sets the password, revokes old tokens, and signs the user in" do
      expected_shape = gql.mutation(:user_reset_password) do |m|
        m.prop :viewer_token do |vt|
          vt[:token] = be_present
        end

        m.prop :user do |u|
          u[:id] = resetting.to_encoded_id
        end
      end

      expect_request! do |req|
        req.effect! change { resetting.reload.valid_password?(new_password) }.from(false).to(true)
        req.effect! keep_the_same { resetting.allowlisted_jwts.count }

        req.data! expected_shape
      end

      expect(resetting.allowlisted_jwts.pluck(:jti)).to contain_exactly(
        Warden::JWTAuth::TokenDecoder.new.call(graphql_response(:data, :userResetPassword, :viewerToken, :token))["jti"]
      )
    end

    context "when the user may not use the API" do
      let(:resetting) { regular_user }

      it "sets the password without signing in" do
        expected_shape = gql.mutation(:user_reset_password) do |m|
          m[:viewer_token] = be_blank
          m[:user] = be_blank
        end

        expect_request! do |req|
          req.effect! change { resetting.reload.valid_password?(new_password) }.to(true)
          req.effect! change { resetting.allowlisted_jwts.count }.to(0)

          req.data! expected_shape
        end
      end
    end

    context "with an invalid token" do
      let(:raw_token) { "not-a-token" }

      it "fails" do
        expected_shape = gql.mutation(:user_reset_password, no_errors: false) do |m|
          m[:viewer_token] = be_blank

          m.attribute_errors do |ae|
            ae.error :reset_password_token, /is invalid/
          end
        end

        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "with a mismatched confirmation" do
      let(:confirmation) { "something else" }

      it "fails" do
        expected_shape = gql.mutation(:user_reset_password, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :password_confirmation, :must_match_password
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { resetting.reload.encrypted_password }

          req.data! expected_shape
        end
      end
    end
  end
end
