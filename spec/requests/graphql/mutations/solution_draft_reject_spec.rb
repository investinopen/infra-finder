# frozen_string_literal: true

RSpec.describe Mutations::SolutionDraftReject, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionDraftReject($input: SolutionDraftRejectInput!) {
    solutionDraftReject(input: $input) {
      solutionDraft {
        currentState
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:solution_draft, refind: true) { solution.create_draft!(user: editor).tap(&:request_review!) }

  let_mutation_input!(:solution_draft_id) { solution_draft.to_encoded_id }
  let_mutation_input!(:memo) { "A memo" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_draft_reject }

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
    it "rejects the draft" do
      expect_request! do |req|
        req.effect! change { solution_draft.current_state(force_reload: true) }.from("in_review").to("rejected")

        req.data! gql.mutation(:solution_draft_reject) { |m| m.prop(:solution_draft) { |d| d[:current_state] = "REJECTED" } }
      end

      expect(solution_draft.last_transition.memo).to eq "A memo"
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"

    context "when the draft is pending" do
      before { solution_draft.request_revision! }

      include_examples "an unauthorized mutation"
    end
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
