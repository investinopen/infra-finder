# frozen_string_literal: true

RSpec.describe Mutations::ProviderUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ProviderUpdate($input: ProviderUpdateInput!) {
    providerUpdate(input: $input) {
      provider {
        name
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_mutation_input!(:provider_id) { provider.to_encoded_id }
  let_mutation_input!(:name) { "Renamed" }

  let(:empty_mutation_shape) { gql.empty_mutation :provider_update }

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
    it "updates the provider" do
      expect_request! do |req|
        req.effect! change { provider.reload.name }.to("Renamed")

        req.data! gql.mutation(:provider_update) { |m| m.prop(:provider) { |p| p[:name] = "Renamed" } }
      end
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end
end
