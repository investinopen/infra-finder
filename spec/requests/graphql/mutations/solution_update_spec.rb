# frozen_string_literal: true

RSpec.describe Mutations::SolutionUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionUpdate($input: SolutionUpdateInput!) {
    solutionUpdate(input: $input) {
      solution {
        name
        mission
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_mutation_input!(:solution_id) { solution.to_encoded_id }
  let_mutation_input!(:mission) { "A new mission" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_update }

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
    it "changes nothing and reports the error on #{path}" do
      expect_request! do |req|
        req.effect! keep_the_same { solution.reload.attributes }

        req.data! gql.mutation(:solution_update, no_errors: false) do |m|
          m[:solution] = be_blank

          m.attribute_errors { |ae| ae.error path, message }
        end
      end

      expect(graphql_response(:data, :solutionUpdate, :attributeErrors))
        .to contain_exactly(include("path" => path.to_s.camelize(:lower), "messages" => [match(message)]))
    end
  end

  shared_examples_for "an authorized mutation" do
    it "updates the solution and records a direct revision" do
      expected_shape = gql.mutation(:solution_update) do |m|
        m.prop(:solution) do |s|
          s[:name] = solution.name
          s[:mission] = "A new mission"
        end
      end

      expect_request! do |req|
        req.effect! change { solution.reload.mission }.to("A new mission")
        req.effect! change { solution.solution_revisions.direct_revision.count }.by(1)

        req.data! expected_shape
      end

      expect(solution.reload).not_to be_complete
    end

    context "with a blank name" do
      let_mutation_input!(:name) { "" }

      include_examples "a refused mutation", :name, /blank/
    end

    context "without a provider" do
      let_mutation_input!(:provider_id) { nil }

      include_examples "a refused mutation", :provider_id, /must exist/
    end

    context "with a value over its max length" do
      let_mutation_input!(:service_summary) { "a" * 1001 }

      include_examples "a refused mutation", :service_summary, /too long/
    end

    context "with a malformed website" do
      let_mutation_input!(:website) { "example.org" }

      include_examples "a refused mutation", :website, /valid URL/
    end

    context "with a malformed implementation link" do
      let_mutation_input!(:code_repository) { { links: [{ label: "Repo", url: "not a url" }] } }

      include_examples "a refused mutation", :code_repository, /invalid/
    end
  end

  as_a_super_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
