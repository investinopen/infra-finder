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
