# frozen_string_literal: true

RSpec.describe Mutations::UserUnlock, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserUnlock($input: UserUnlockInput!) {
    userUnlock(input: $input) {
      unlocked
      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:locked) { admin_user }

  let(:raw_token) do
    locked.lock_access!(send_instructions: false)

    locked.send_unlock_instructions
  end

  let_mutation_input!(:unlock_token) { raw_token }

  as_an_anonymous_user do
    it "unlocks the account" do
      raw_token

      expected_shape = gql.mutation(:user_unlock) do |m|
        m[:unlocked] = true
      end

      expect_request! do |req|
        req.effect! change { locked.reload.access_locked? }.from(true).to(false)

        req.data! expected_shape
      end
    end

    context "with an invalid token" do
      let(:raw_token) { "not-a-token" }

      it "fails" do
        expected_shape = gql.mutation(:user_unlock, no_errors: false) do |m|
          m[:unlocked] = be_blank

          m.attribute_errors do |ae|
            ae.error :unlock_token, /is invalid/
          end
        end

        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end
end
