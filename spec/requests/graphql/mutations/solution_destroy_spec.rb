# frozen_string_literal: true

RSpec.describe Mutations::SolutionDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionDestroy($input: SolutionDestroyInput!) {
    solutionDestroy(input: $input) {
      destroyed
      destroyedId
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:solution_attrs) do
    {}
  end

  let_it_be(:solution, refind: true) { FactoryBot.create(:solution, **solution_attrs) }

  let_mutation_input!(:solution_id) { solution.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:solution_destroy) do |m|
      m[:destroyed] = true
      m[:destroyed_id] = be_an_encoded_id.of_a_deleted_model
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :solution_destroy
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "destroys the solution" do
      expect_request! do |req|
        req.effect! change(Solution, :count).by(-1)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(Solution, :count)

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an authorized mutation" do
    include_examples "a successful mutation"
  end

  as_a_super_admin_user do
    include_examples "an authorized mutation"

    context "when the solution has a draft and revisions" do
      before do
        solution.create_draft!(user: super_admin_user)
        solution.create_revision!(kind: "direct")
      end

      include_examples "an authorized mutation"
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
