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

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms, editor_for: provider) }

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

    context "when a required property is cleared" do
      let_mutation_input!(:mission) { nil }

      it "saves the incomplete draft" do
        expect_request! do |req|
          req.effect! change { solution_draft.reload.mission }.to(nil)
        end
      end
    end

    context "with too many choices" do
      let_mutation_input!(:solution_category_ids) { FactoryBot.create_list(:solution_category, 4).map(&:to_encoded_id) }

      it "reports them on the input and changes nothing" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.reload.solution_category_ids.sort }

          req.data! gql.mutation(:solution_draft_update, no_errors: false) do |m|
            m[:solution_draft] = be_blank

            m.attribute_errors { |ae| ae.error :solution_category_ids, /too many/i }
          end
        end
      end

      context "and other invalid values" do
        let_mutation_input!(:name) { "" }

        it "reports every error" do
          expect_request! do |req|
            req.effect! keep_the_same { solution_draft.reload.name }

            req.data! gql.mutation(:solution_draft_update, no_errors: false) do |m|
              m[:solution_draft] = be_blank

              m.attribute_errors do |ae|
                ae.error :solution_category_ids, /too many/i
                ae.error :name, /blank/
              end
            end
          end
        end
      end
    end

    context "with an invalid value" do
      let_mutation_input!(:mission) { "a" * 5000 }

      it "changes nothing" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.reload.mission }

          req.data! gql.mutation(:solution_draft_update, no_errors: false) do |m|
            m[:solution_draft] = be_blank

            m.attribute_errors { |ae| ae.error :mission, /too long/ }
          end
        end
      end
    end

    context "with a malformed URL and email" do
      let_mutation_input!(:board_members_url) { "example.org/board" }
      let_mutation_input!(:email) { "someone" }

      it "reports both on their fields" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.reload.board_members_url }

          req.data! gql.mutation(:solution_draft_update, no_errors: false) do |m|
            m[:solution_draft] = be_blank

            m.attribute_errors do |ae|
              ae.error :board_members_url, /valid URL/
              ae.error :email, /invalid/
            end
          end
        end
      end
    end

    context "when the editor validations fail" do
      let_mutation_input!(:name) { "" }

      it "changes nothing" do
        expect_request! do |req|
          req.effect! keep_the_same { solution_draft.reload.name }

          req.data! gql.mutation(:solution_draft_update, no_errors: false) do |m|
            m[:solution_draft] = be_blank

            m.attribute_errors { |ae| ae.error :name, /blank/ }
          end
        end
      end
    end
  end

  context "as the solution's editor" do
    let(:current_user) { editor }
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_editor_user do
    context "with no access" do
      include_examples "an unauthorized mutation"
    end

    context "when an editor on the provider" do
      let(:current_user) { editor }

      include_examples "an authorized mutation"

      describe "the arguments" do
        context "when setting each kind of property" do
          let_mutation_input!(:license_ids) { [license.to_encoded_id] }
          let_mutation_input!(:board_level_id) { board_level.to_encoded_id }
          let_mutation_input!(:annual_revenue) { "1234.50" }
          let_mutation_input!(:code_repository_implementation) { "AVAILABLE" }
          let_mutation_input!(:code_repository) { { links: [{ label: "Repo", url: "https://example.org/repo" }], statement: "Public" } }
          let_mutation_input!(:code_license) { { link: { url: "https://example.org/license" } } }
          let_mutation_input!(:recent_grants) { [{ name: "Big Grant", funder: "Foundation" }] }

          it "handles each property correctly" do
            expect_request! do |req|
              req.effect! change { solution_draft.reload.licenses.to_a }.from([]).to([license])
              req.effect! change { solution_draft.reload.board_level }.from(nil).to(board_level)
              req.effect! change { solution_draft.reload.annual_revenue_cents }.from(0).to(123_450)
              req.effect! change { solution_draft.reload.code_repository_implementation }.from("unknown").to("available")
              req.effect! change { solution_draft.reload.code_repository.links.map(&:url) }.from([]).to(["https://example.org/repo"])
              req.effect! change { solution_draft.reload.code_repository.statement }.from(nil).to("Public")
              req.effect! change { solution_draft.reload.code_license.link.url }.from(nil).to("https://example.org/license")
              req.effect! change { solution_draft.reload.recent_grants.map(&:name) }.from([]).to(["Big Grant"])
            end
          end
        end

        it "leaves omitted properties as they are" do
          solution_draft.update!(licenses: [license], board_level:, code_repository_implementation: "available")

          expect_request! do |req|
            req.effect! keep_the_same { solution_draft.reload.licenses.to_a }
            req.effect! keep_the_same { solution_draft.reload.board_level }
            req.effect! keep_the_same { solution_draft.reload.code_repository_implementation }
            req.effect! keep_the_same { solution_draft.reload.mission }
          end
        end

        context "when setting null on a property" do
          let_mutation_input!(:key_achievements) { nil }

          it "clears the property" do
            solution_draft.update!(key_achievements: "Achieved")

            expect_request! do |req|
              req.effect! change { solution_draft.reload.key_achievements }.from("Achieved").to(nil)
            end
          end
        end

        context "when setting null on a list" do
          let_mutation_input!(:license_ids) { nil }

          it "refuses the value with the proper GQL error" do
            expect_request! do |req|
              req.effect! keep_the_same { solution_draft.reload.updated_at }

              req.non_null! :license_ids
            end
          end
        end

        context "when setting an implementation status" do
          let_mutation_input!(:pricing_implementation) { "NOT_APPLICABLE" }

          it "only accepts valid implementation statuses" do
            expect_request! do |req|
              req.effect! keep_the_same { solution_draft.reload.updated_at }

              req.invalid_enum_value!("NOT_APPLICABLE", ::Types::PricingImplementationStatusType)
            end
          end
        end
      end

      context "when the draft is under review" do
        before do
          solution_draft.request_review!
        end

        include_examples "an unauthorized mutation"
      end

      context "when the draft is approved" do
        before do
          solution_draft.request_review!
          solution_draft.approve!
        end

        include_examples "an unauthorized mutation"
      end
    end
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
