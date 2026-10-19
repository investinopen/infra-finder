# frozen_string_literal: true

RSpec.describe Mutations::SolutionIntakeUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionIntakeUpdate($input: SolutionIntakeUpdateInput!) {
    solutionIntakeUpdate(input: $input) {
      solutionIntake {
        name
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:solution_intake, refind: true) { FactoryBot.create :solution_intake }

  let_mutation_input!(:solution_intake_id) { solution_intake.to_encoded_id }
  let_mutation_input!(:name) { "Renamed" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_intake_update }

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
    it "saves progress without the editor validations" do
      expect_request! do |req|
        req.effect! change { solution_intake.reload.name }.to("Renamed")

        req.data! gql.mutation(:solution_intake_update) { |m| m.prop(:solution_intake) { |i| i[:name] = "Renamed" } }
      end
    end
  end

  as_an_anonymous_user do
    include_examples "an authorized mutation"

    context "when setting the provider" do
      let_mutation_input!(:provider_id) { provider.to_encoded_id }

      it "refuses" do
        expected_shape = gql.mutation(:solution_intake_update, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :provider_id, :must_be_set_by_an_admin
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { solution_intake.reload.provider_id }

          req.data! expected_shape
        end
      end
    end

    context "when uploading a logo" do
      let_mutation_input!(:logo) { graphql_upload_from("spec", "data", "lorempixel.jpg") }
      let_mutation_input!(:logo_metadata) { { alt: "The solution's logo" } }

      it "attaches it" do
        expect_request! do |req|
          req.effect! change { solution_intake.reload.logo.present? }.from(false).to(true)

          req.data! gql.mutation(:solution_intake_update) { |m| m.prop(:solution_intake) { |i| i[:name] = "Renamed" } }
        end

        expect(solution_intake.logo_alt).to eq "The solution's logo"
      end
    end

    context "when clearing a logo" do
      before do
        solution_intake.update!(logo: Rails.root.join("spec", "data", "logo.svg").open("r"))
      end

      let_mutation_input!(:clear_logo) { true }

      it "removes it" do
        expect_request! do |req|
          req.effect! change { solution_intake.reload.logo.present? }.from(true).to(false)
        end
      end
    end

    context "when the intake is in review" do
      before { solution_intake.transition_to!(:in_review) }

      include_examples "an unauthorized mutation"
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"

    context "when setting the provider" do
      let_mutation_input!(:provider_id) { provider.to_encoded_id }

      it "assigns it" do
        expect_request! do |req|
          req.effect! change { solution_intake.reload.provider }.to(provider)
        end
      end
    end
  end
end
