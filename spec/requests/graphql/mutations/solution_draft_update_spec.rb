# frozen_string_literal: true

RSpec.describe Mutations::SolutionDraftUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionDraftUpdate($input: SolutionDraftUpdateInput!) {
    solutionDraftUpdate(input: $input) {
      solutionDraft {
        name
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:license, refind: true) { FactoryBot.create :license }

  let_it_be(:board_level, refind: true) { FactoryBot.create :reporting_level }

  let_it_be(:solution_draft, refind: true) do
    solution.create_draft!(user: editor).tap { _1.update!(complete_solution_attributes(:draft)) }
  end

  let_mutation_input!(:solution_draft_id) { solution_draft.to_encoded_id }
  let_mutation_input!(:name) { "Renamed" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_draft_update }

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
    it "updates the draft" do
      expect_request! do |req|
        req.effect! change { solution_draft.reload.name }.to("Renamed")

        req.data! gql.mutation(:solution_draft_update) { |m| m.prop(:solution_draft) { |d| d[:name] = "Renamed" } }
      end
    end

    context "when the editor validations fail" do
      let_mutation_input!(:name) { "" }

      it "changes nothing" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.reload.name }

          req.data! gql.mutation(:solution_draft_update, no_global_errors: false) { |m| m[:solution_draft] = be_blank }
        end
      end
    end
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an authorized mutation"

    describe "the arguments" do
      it "sets each kind of property" do
        make_default_request!(override_inputs: {
          license_ids: [license.to_encoded_id],
          board_level_id: board_level.to_encoded_id,
          annual_revenue: "1234.50",
          code_repository_implementation: "AVAILABLE",
          code_repository: { links: [{ label: "Repo", url: "https://example.org/repo" }], statement: "Public" },
          code_license: { link: { url: "https://example.org/license" } },
          recent_grants: [{ name: "Big Grant", funder: "Foundation" }],
        })

        solution_draft.reload

        expect(solution_draft).to have_attributes(licenses: [license], board_level:, code_repository_implementation: "available")
        expect(solution_draft.annual_revenue_cents).to eq 123_450
        expect(solution_draft.code_repository.links.map(&:url)).to eq ["https://example.org/repo"]
        expect(solution_draft.code_repository.statement).to eq "Public"
        expect(solution_draft.code_license.link.url).to eq "https://example.org/license"
        expect(solution_draft.recent_grants.map(&:name)).to eq ["Big Grant"]
      end

      it "leaves omitted properties as they are" do
        solution_draft.update!(licenses: [license], board_level:, code_repository_implementation: "available")

        expect do
          make_default_request!
        end.to keep_the_same { solution_draft.reload.licenses.to_a }
          .and keep_the_same { solution_draft.reload.board_level }
          .and keep_the_same { solution_draft.reload.code_repository_implementation }
          .and keep_the_same { solution_draft.reload.mission }
      end

      it "clears a property given null" do
        solution_draft.update!(key_achievements: "Achieved")

        expect do
          make_default_request!(override_inputs: { key_achievements: nil })
        end.to change { solution_draft.reload.key_achievements }.from("Achieved").to(nil)
      end

      it "refuses null for a list" do
        make_default_request!(override_inputs: { license_ids: nil }, no_top_level_errors: false)

        expect(graphql_response(:errors).pluck("message")).to eq ["licenseIds can't be null"]
      end

      it "only accepts the statuses an implementation has" do
        make_default_request!(override_inputs: { pricing_implementation: "NOT_APPLICABLE" }, no_top_level_errors: false)

        expect(graphql_response(:errors).first["message"]).to include("NOT_APPLICABLE")
      end
    end

    context "when the draft is approved" do
      before do
        solution_draft.request_review!
        solution_draft.approve!
      end

      include_examples "an unauthorized mutation"
    end
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
