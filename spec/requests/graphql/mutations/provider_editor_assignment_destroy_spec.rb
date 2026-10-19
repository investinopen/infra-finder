# frozen_string_literal: true

RSpec.describe Mutations::ProviderEditorAssignmentDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ProviderEditorAssignmentDestroy($input: ProviderEditorAssignmentDestroyInput!) {
    providerEditorAssignmentDestroy(input: $input) {
      destroyed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:assignment, refind: true) { FactoryBot.create(:provider).assign_editor!(FactoryBot.create(:user)) }

  let_mutation_input!(:provider_editor_assignment_id) { assignment.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :provider_editor_assignment_destroy }

  as_a_super_admin_user do
    it "removes the assignment" do
      expect_request! do |req|
        req.effect! change(ProviderEditorAssignment, :count).by(-1)

        req.data! gql.mutation(:provider_editor_assignment_destroy) { |m| m[:destroyed] = true }
      end
    end
  end

  as_an_admin_user do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end
end
