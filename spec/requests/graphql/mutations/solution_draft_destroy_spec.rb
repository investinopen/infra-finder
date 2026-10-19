# frozen_string_literal: true

RSpec.describe Mutations::SolutionDraftDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionDraftDestroy($input: SolutionDraftDestroyInput!) {
    solutionDraftDestroy(input: $input) {
      destroyed
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:solution_draft, refind: true) { solution.create_draft!(user: editor) }

  let_mutation_input!(:solution_draft_id) { solution_draft.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_draft_destroy }

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
    it "destroys the draft" do
      expect_request! do |req|
        req.effect! change(SolutionDraft, :count).by(-1)

        req.data! gql.mutation(:solution_draft_destroy) { |m| m[:destroyed] = true }
      end
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an authorized mutation"

    context "when the draft is in review" do
      before { solution_draft.request_review! }

      include_examples "an unauthorized mutation"
    end
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
