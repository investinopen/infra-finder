# frozen_string_literal: true

RSpec.describe Mutations::SolutionDraftRequestReview, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionDraftRequestReview($input: SolutionDraftRequestReviewInput!) {
    solutionDraftRequestReview(input: $input) {
      solutionDraft {
        currentState

        canUpdate {
          ... AuthorizationResultFragment
        }

        canDestroy {
          ... AuthorizationResultFragment
        }

        transitions {
          nodes {
            fromState
            toState
            memo

            initiator {
              id
            }
          }
        }
      }

      ... ErrorFragment
    }
  }

  fragment AuthorizationResultFragment on AuthorizationResult {
    value
    message
    reasons {
      details
      fullMessages
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider:, **complete_solution_attributes(:actual) }

  let_it_be(:solution_draft, refind: true) { solution.create_draft!(user: editor) }

  let_mutation_input!(:solution_draft_id) { solution_draft.to_encoded_id }
  let_mutation_input!(:memo) { "A memo" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_draft_request_review }

  let(:can_update) { false }

  let(:can_destroy) { false }

  let(:valid_mutation_shape) do
    gql.mutation(:solution_draft_request_review) do |m|
      m.prop(:solution_draft) do |d|
        d[:current_state] = "IN_REVIEW"

        d.auth_results(can_update:, can_destroy:)

        d.prop :transitions do |t|
          t.array :nodes do |n|
            n.item do |trx|
              trx[:from_state] = "PENDING"
              trx[:to_state] = "IN_REVIEW"
              trx[:memo] = "A memo"

              trx.prop :initiator do |i|
                i[:id] = current_user.to_encoded_id
              end
            end
          end
        end
      end
    end
  end

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
    it "submits the draft for review" do
      expect_request! do |req|
        req.effect! change { solution_draft.current_state(force_reload: true) }.from("pending").to("in_review")

        req.data! valid_mutation_shape
      end
    end

    context "when the draft is incomplete" do
      let(:expected_shape) do
        gql.mutation(:solution_draft_request_review, no_errors: false) do |m|
          m[:solution_draft] = be_blank

          m.attribute_errors do |ae|
            ae.error :service_summary, /can't be blank/
            ae.error :mission, /can't be blank/
          end
        end
      end

      before do
        solution_draft.update_columns(mission: nil, service_summary: nil)
      end

      it "returns an error for each missing property and leaves the draft pending" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.current_state(force_reload: true) }

          req.data! expected_shape
        end
      end
    end
  end

  context "as the solution's editor" do
    let(:current_user) { editor }
    let(:can_update) { false }
    let(:can_destroy) { false }

    include_examples "an authorized mutation"

    context "when the draft is in review" do
      before { solution_draft.request_review! }

      include_examples "an unauthorized mutation"
    end
  end

  as_a_super_admin_user do
    let(:can_update) { true }
    let(:can_destroy) { true }

    include_examples "an authorized mutation"
  end

  as_an_admin_user do
    let(:can_update) { true }
    let(:can_destroy) { false }

    include_examples "an authorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
