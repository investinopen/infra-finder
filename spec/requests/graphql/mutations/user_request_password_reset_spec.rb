# frozen_string_literal: true

RSpec.describe Mutations::UserRequestPasswordReset, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserRequestPasswordReset($input: UserRequestPasswordResetInput!) {
    userRequestPasswordReset(input: $input) {
      requested
      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:target_email) { editor_user.email }

  let_mutation_input!(:email) { target_email }

  let(:valid_mutation_shape) do
    gql.mutation(:user_request_password_reset) do |m|
      m[:requested] = true
    end
  end

  as_an_anonymous_user do
    it "emails reset instructions" do
      expect_request! do |req|
        req.effect! change(ActionMailer::Base.deliveries, :count).by(1)
        req.effect! change { editor_user.reload.reset_password_token }

        req.data! valid_mutation_shape
      end
    end

    context "with an unknown email" do
      let(:target_email) { "nobody@example.com" }

      it "reports success without sending anything" do
        expect_request! do |req|
          req.effect! keep_the_same(ActionMailer::Base.deliveries, :count)

          req.data! valid_mutation_shape
        end
      end
    end

    context "when too many requests have come from this IP" do
      before do
        limit, = Users::Throttle::LIMITS.fetch(:password_reset)

        limit.times { Users::Throttle.exceeded?(:password_reset, "127.0.0.1") }
      end

      it "refuses" do
        expected_shape = gql.mutation(:user_request_password_reset, no_global_errors: false) do |m|
          m[:requested] = be_blank

          m.global_errors do |ge|
            ge.error(/\A#{Regexp.escape(I18n.t("server_messages.auth.throttled"))}\z/, type: "throttled")
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(ActionMailer::Base.deliveries, :count)

          req.data! expected_shape
        end
      end
    end
  end
end
