# frozen_string_literal: true

RSpec.describe Mutations::UserSignIn, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserSignIn($input: UserSignInInput!) {
    userSignIn(input: $input) {
      viewerToken {
        token
        expiresAt
      }
      user {
        id
        email
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:correct_password) { "correct horse battery staple" }

  let_it_be(:admin_with_password, refind: true) { FactoryBot.create :user, :with_admin, password: correct_password }

  let(:signing_in) { admin_with_password }

  let(:attempted_password) { correct_password }

  let_mutation_input!(:email) { signing_in.email }
  let_mutation_input!(:password) { attempted_password }

  def refused_shape(type, message)
    gql.mutation(:user_sign_in, no_global_errors: false) do |m|
      m[:viewer_token] = be_blank
      m[:user] = be_blank

      m.global_errors do |ge|
        ge.error(/\A#{Regexp.escape(message)}\z/, type:)
      end
    end
  end

  as_an_anonymous_user do
    it "issues an allowlisted token for the user" do
      expected_shape = gql.mutation(:user_sign_in) do |m|
        m.prop :viewer_token do |vt|
          vt[:token] = be_present
          vt[:expires_at] = be_present
        end

        m.prop :user do |u|
          u[:id] = be_an_encoded_id.of_an_existing_model
          u[:email] = signing_in.email
        end
      end

      expect_request! do |req|
        req.effect! change(AllowlistedJwt, :count).by(1)
        req.effect! change { signing_in.reload.sign_in_count }.by(1)

        req.data! expected_shape
      end
    end

    it "issues a token that authenticates later requests" do
      make_default_request!

      token = graphql_response(:data, :userSignIn, :viewerToken, :token)

      make_graphql_request! "query { viewer { email } }", token:, operation: nil

      expect(graphql_response(:data, :viewer, :email)).to eq signing_in.email
    end

    context "with the wrong password" do
      let(:attempted_password) { "wrong" }

      it "refuses and counts a failed attempt" do
        expect_request! do |req|
          req.effect! keep_the_same(AllowlistedJwt, :count)
          req.effect! change { signing_in.reload.failed_attempts }.by(1)

          req.data! refused_shape("invalid", "Invalid email or password.")
        end
      end
    end

    context "with an unknown email" do
      let_mutation_input!(:email) { "nobody@example.com" }

      it "refuses" do
        expect_request! do |req|
          req.data! refused_shape("invalid", "Invalid email or password.")
        end
      end
    end

    context "when the account is locked" do
      before { signing_in.lock_access!(send_instructions: false) }

      it "refuses" do
        expect_request! do |req|
          req.effect! keep_the_same(AllowlistedJwt, :count)

          req.data! refused_shape("locked", I18n.t("devise.failure.locked"))
        end
      end

      context "with the wrong password" do
        let(:attempted_password) { "wrong" }

        it "does not reveal the account state" do
          expect_request! do |req|
            req.data! refused_shape("invalid", "Invalid email or password.")
          end
        end
      end
    end

    context "when the account is unconfirmed" do
      let(:signing_in) { FactoryBot.create :user, :with_admin, password: correct_password, confirmed: false }

      it "refuses" do
        expect_request! do |req|
          req.data! refused_shape("unconfirmed", I18n.t("devise.failure.unconfirmed"))
        end
      end

      context "with the wrong password" do
        let(:attempted_password) { "wrong" }

        it "does not reveal the account state" do
          expect_request! do |req|
            req.data! refused_shape("invalid", "Invalid email or password.")
          end
        end
      end
    end

    context "when the user has neither admin nor editor access" do
      let(:signing_in) { FactoryBot.create :user, :accepted_terms, password: correct_password }

      it "refuses" do
        expect_request! do |req|
          req.effect! keep_the_same(AllowlistedJwt, :count)

          req.data! refused_shape("no_access", I18n.t("server_messages.tokens.inactive"))
        end
      end
    end

    context "when too many attempts have come from this IP" do
      before do
        limit, = Users::Throttle::LIMITS.fetch(:sign_in)

        limit.times { Users::Throttle.exceeded?(:sign_in, "127.0.0.1") }
      end

      it "refuses without checking the password" do
        expect_request! do |req|
          req.effect! keep_the_same { signing_in.reload.failed_attempts }

          req.data! refused_shape("throttled", I18n.t("server_messages.auth.throttled"))
        end
      end
    end
  end
end
