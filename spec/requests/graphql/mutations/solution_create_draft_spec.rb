# frozen_string_literal: true

RSpec.describe Mutations::SolutionCreateDraft, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionCreateDraft($input: SolutionCreateDraftInput!) {
    solutionCreateDraft(input: $input) {
      solutionDraft {
        currentState
        solution { name }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_mutation_input!(:solution_id) { solution.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_create_draft }

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
    it "creates a pending draft" do
      expected_shape = gql.mutation(:solution_create_draft) do |m|
        m.prop(:solution_draft) do |d|
          d[:current_state] = "PENDING"
          d[:solution] = { name: solution.name }
        end
      end

      expect_request! do |req|
        req.effect! change(SolutionDraft, :count).by(1)

        req.data! expected_shape
      end
    end

    context "when the user already has a pending draft" do
      before { solution.create_draft!(user: current_user) }

      it "refuses" do
        expected_shape = gql.mutation(:solution_create_draft, no_global_errors: false) do |m|
          m[:solution_draft] = be_blank

          m.global_errors do |ge|
            ge.error(/\A#{Regexp.escape(I18n.t("admin.solutions.create_draft.pending_draft_exists"))}\z/, type: "pending_draft_exists")
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(SolutionDraft, :count)

          req.data! expected_shape
        end
      end
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an authorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
