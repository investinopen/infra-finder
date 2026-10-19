# frozen_string_literal: true

RSpec.describe Mutations::ProviderDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ProviderDestroy($input: ProviderDestroyInput!) {
    providerDestroy(input: $input) {
      destroyed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_mutation_input!(:provider_id) { provider.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :provider_destroy }

  as_a_super_admin_user do
    it "destroys the provider" do
      expect_request! do |req|
        req.effect! change(Provider, :count).by(-1)

        req.data! gql.mutation(:provider_destroy) { |m| m[:destroyed] = true }
      end
    end

    context "when the provider has editors" do
      let_it_be(:editor, refind: true) { FactoryBot.create(:user).tap { provider.assign_editor!(_1) } }

      it "reverts them to unassigned" do
        expect_request! do |req|
          req.effect! change { editor.reload.kind }.from("editor").to("unassigned")
        end
      end
    end

    context "when the provider has solutions" do
      before { FactoryBot.create :solution, provider: }

      it "refuses" do
        expect_request! do |req|
          req.effect! keep_the_same(Provider, :count)

          req.data! gql.mutation(:provider_destroy, no_global_errors: false) { |m| m[:destroyed] = be_blank }
        end
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
