# frozen_string_literal: true

RSpec.describe Mutations::InvitationCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation InvitationCreate($input: InvitationCreateInput!) {
    invitationCreate(input: $input) {
      invitation {
        email
        admin { email }
        user { email }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let(:invitee_email) { "invitee@example.com" }

  let_mutation_input!(:provider_id) { provider.to_encoded_id }
  let_mutation_input!(:email) { invitee_email }
  let_mutation_input!(:first_name) { "In" }
  let_mutation_input!(:last_name) { "Vitee" }

  let(:empty_mutation_shape) { gql.empty_mutation :invitation_create }

  as_an_admin_user do
    it "invites the user" do
      expected_shape = gql.mutation(:invitation_create) do |m|
        m.prop(:invitation) do |i|
          i[:email] = invitee_email
          i.prop(:admin) { |a| a[:email] = admin_user.email }
          i.prop(:user) { |u| u[:email] = invitee_email }
        end
      end

      expect_request! do |req|
        req.effect! change(Invitation, :count).by(1).and change(User, :count).by(1)

        req.data! expected_shape
      end
    end

    context "when the email is already registered" do
      let(:invitee_email) { FactoryBot.create(:user).email }

      it "refuses" do
        expect_request! do |req|
          req.effect! keep_the_same(User, :count).and keep_the_same(Invitation, :count)

          req.data! gql.mutation(:invitation_create, no_global_errors: false) { |m| m[:invitation] = be_blank }
        end
      end
    end
  end

  as_an_editor_user do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end
end
