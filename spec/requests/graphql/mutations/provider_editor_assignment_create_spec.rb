# frozen_string_literal: true

RSpec.describe Mutations::ProviderEditorAssignmentCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ProviderEditorAssignmentCreate($input: ProviderEditorAssignmentCreateInput!) {
    providerEditorAssignmentCreate(input: $input) {
      providerEditorAssignment {
        user { email }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:user, refind: true) { FactoryBot.create :user }

  let_mutation_input!(:provider_id) { provider.to_encoded_id }
  let_mutation_input!(:user_id) { user.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :provider_editor_assignment_create }

  as_an_admin_user do
    it "makes the user an editor" do
      expect_request! do |req|
        req.effect! change { user.reload.kind }.from("unassigned").to("editor")

        req.data! gql.mutation(:provider_editor_assignment_create) { |m| m.prop(:provider_editor_assignment) { |a| a.prop(:user) { |u| u[:email] = user.email } } }
      end
    end

    context "when the user is already an editor of the provider" do
      before { provider.assign_editor!(user) }

      it "refuses" do
        expect_request! do |req|
          req.effect! keep_the_same(ProviderEditorAssignment, :count)

          req.data! gql.mutation(:provider_editor_assignment_create, no_global_errors: false) { |m| m[:provider_editor_assignment] = be_blank }
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
