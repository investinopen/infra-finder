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

  let(:provider_id) { provider.to_encoded_id }

  let(:graphql_variables) { { input: attributes.merge(name:, provider_id:).compact } }

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

  shared_examples_for "a refused mutation" do |path, message|
    it "creates nothing and reports the error on #{path}" do
      expect_request! do |req|
        req.effect! keep_the_same(Solution, :count)

        req.data! gql.mutation(:solution_create, no_errors: false) do |m|
          m[:solution] = be_blank

          m.attribute_errors { |ae| ae.error path, message }
        end
      end

      expect(graphql_response(:data, :solutionCreate, :attributeErrors))
        .to contain_exactly(include("path" => path.to_s.camelize(:lower), "messages" => [match(message)]))
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

    context "with only a name and provider" do
      let(:attributes) { { name: "Incomplete solution" } }

      it "creates an incomplete solution and its initial revision" do
        expect_request! do |req|
          req.effect! change(Solution, :count).by(1)
          req.effect! change(SolutionRevision, :count).by(1)
        end

        expect(Solution.find_by!(name: "Incomplete solution")).not_to be_complete
      end
    end

    context "with a blank name" do
      let(:name) { "" }

      include_examples "a refused mutation", :name, /blank/
    end

    context "without a provider" do
      let(:provider_id) { nil }

      include_examples "a refused mutation", :provider_id, /must exist/
    end

    context "with a value over its max length" do
      let(:attributes) { complete_solution_input(:actual).merge(service_summary: "a" * 1001) }

      include_examples "a refused mutation", :service_summary, /too long/
    end

    context "with a malformed website" do
      let(:attributes) { complete_solution_input(:actual).merge(website: "example.org") }

      include_examples "a refused mutation", :website, /valid URL/
    end

    context "with a malformed implementation link" do
      let(:attributes) { complete_solution_input(:actual).merge(code_repository: { links: [{ label: "Repo", url: "not a url" }] }) }

      include_examples "a refused mutation", :code_repository, /invalid/
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
