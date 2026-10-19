# frozen_string_literal: true

RSpec.describe Mutations::SolutionsPublish, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionsPublish($input: SolutionsPublishInput!) {
    solutionsPublish(input: $input) {
      solutions {
        publication
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:unpublished_solution, refind: true) { FactoryBot.create :solution }

  let_it_be(:published_solution, refind: true) { FactoryBot.create(:solution).tap(&:published!) }

  let_mutation_input!(:solution_ids) { [unpublished_solution, published_solution].map(&:to_encoded_id) }

  let(:empty_mutation_shape) { gql.empty_mutation :solutions_publish }

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
    it "publishes the solutions" do
      expected_shape = gql.mutation(:solutions_publish) do |m|
        m[:solutions] = [{ publication: "PUBLISHED" }, { publication: "PUBLISHED" }]
      end

      expect_request! do |req|
        req.effect! change { unpublished_solution.reload.published? }.from(false).to(true)
          .and keep_the_same { published_solution.reload.published_at }

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

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
