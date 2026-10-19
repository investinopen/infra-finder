# frozen_string_literal: true

RSpec.describe Mutations::InvitationDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation InvitationDestroy($input: InvitationDestroyInput!) {
    invitationDestroy(input: $input) {
      destroyed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:invitation, refind: true) { FactoryBot.create :invitation }

  let_mutation_input!(:invitation_id) { invitation.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :invitation_destroy }

  as_an_admin_user do
    it "destroys the invitation" do
      expect_request! do |req|
        req.effect! change(Invitation, :count).by(-1)

        req.data! gql.mutation(:invitation_destroy) { |m| m[:destroyed] = true }
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
