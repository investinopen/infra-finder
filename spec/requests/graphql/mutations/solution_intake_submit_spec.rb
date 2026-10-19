# frozen_string_literal: true

RSpec.describe Mutations::SolutionIntakeSubmit, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionIntakeSubmit($input: SolutionIntakeSubmitInput!) {
    solutionIntakeSubmit(input: $input) {
      solutionIntake {
        currentState
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:solution_intake, refind: true) { FactoryBot.create :solution_intake, :notifiable, launch_year: 2023, **complete_solution_attributes(:intake) }

  let_it_be(:incomplete_intake, refind: true) { FactoryBot.create :solution_intake }

  let_mutation_input!(:solution_intake_id) { solution_intake.to_encoded_id }
  let_mutation_input!(:note) { "A note" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_intake_submit }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  shared_examples_for "a submission" do |source|
    it "submits the intake for review" do
      expect_request! do |req|
        req.effect! change { solution_intake.current_state(force_reload: true) }.from("pending").to("in_review")

        req.data! gql.mutation(:solution_intake_submit) { |m| m.prop(:solution_intake) { |i| i[:current_state] = "IN_REVIEW" } }
      end

      expect(solution_intake.last_transition).to have_attributes(note: "A note", metadata: include("source" => source))
    end
  end

  as_an_anonymous_user do
    include_examples "a submission", "form"

    context "when the intake is incomplete" do
      let_mutation_input!(:solution_intake_id) { incomplete_intake.to_encoded_id }

      it "applies the intake form's validations" do
        expect_request! do |req|
          req.effect! keep_the_same { incomplete_intake.current_state(force_reload: true) }

          req.data! gql.mutation(:solution_intake_submit, no_global_errors: false) { |m| m[:solution_intake] = be_blank }
        end
      end
    end

    context "when the intake is in review" do
      before { solution_intake.transition_to!(:in_review) }

      include_examples "an unauthorized mutation"
    end
  end

  as_an_admin_user do
    include_examples "a submission", "admin"

    context "when the intake is incomplete" do
      let_mutation_input!(:solution_intake_id) { incomplete_intake.to_encoded_id }

      it "skips the intake form's validations" do
        expect_request! do |req|
          req.effect! change { incomplete_intake.current_state(force_reload: true) }.from("pending").to("in_review")
        end
      end
    end
  end
end
