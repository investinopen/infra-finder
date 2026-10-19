# frozen_string_literal: true

RSpec.describe Mutations::ProviderCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ProviderCreate($input: ProviderCreateInput!) {
    providerCreate(input: $input) {
      provider {
        name
        url
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_mutation_input!(:name) { "New Provider" }
  let_mutation_input!(:url) { "https://example.org" }

  let(:empty_mutation_shape) { gql.empty_mutation :provider_create }

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
    it "creates the provider" do
      expected_shape = gql.mutation(:provider_create) do |m|
        m.prop(:provider) do |p|
          p[:name] = "New Provider"
          p[:url] = "https://example.org"
        end
      end

      expect_request! do |req|
        req.effect! change(Provider, :count).by(1)

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end
end
