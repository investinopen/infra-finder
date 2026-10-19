# frozen_string_literal: true

RSpec.describe Mutations::SolutionCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionCreate($input: SolutionCreateInput!) {
    solutionCreate(input: $input) {
      solution {
        name
        provider { name }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let(:attributes) { complete_solution_input(:actual) }

  let(:name) { attributes.fetch(:name) }

  let(:graphql_variables) { { input: attributes.merge(name:, provider_id: provider.to_encoded_id) } }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_create }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  shared_examples_for "an authorized mutation" do
    it "creates the solution and its initial revision" do
      expected_shape = gql.mutation(:solution_create) do |m|
        m.prop(:solution) do |s|
          s[:name] = name
          s[:provider] = { name: provider.name }
        end
      end

      expect_request! do |req|
        req.effect! change(Solution, :count).by(1)
        req.effect! change(SolutionRevision, :count).by(1)

        req.data! expected_shape
      end
    end

    context "when the editor validations fail" do
      let(:name) { "" }

      it "creates nothing" do
        expect_request! do |req|
          req.effect! keep_the_same(Solution, :count)

          req.data! gql.mutation(:solution_create, no_global_errors: false) { |m| m[:solution] = be_blank }
        end
      end
    end
  end

  as_a_super_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
