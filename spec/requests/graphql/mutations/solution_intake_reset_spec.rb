# frozen_string_literal: true

RSpec.describe Mutations::SolutionIntakeReset, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionIntakeReset($input: SolutionIntakeResetInput!) {
    solutionIntakeReset(input: $input) {
      solutionIntake {
        currentState
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:solution_intake, refind: true) do
    FactoryBot.create(:solution_intake).tap do |intake|
      intake.transition_to!(:in_review)
      intake.transition_to!(:rejected)
    end
  end

  let_mutation_input!(:solution_intake_id) { solution_intake.to_encoded_id }
  let_mutation_input!(:note) { "A note" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_intake_reset }

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
    it "resets the intake to pending" do
      expect_request! do |req|
        req.effect! change { solution_intake.current_state(force_reload: true) }.from("rejected").to("pending")

        req.data! gql.mutation(:solution_intake_reset) { |m| m.prop(:solution_intake) { |i| i[:current_state] = "PENDING" } }
      end

      expect(solution_intake.last_transition).to have_attributes(note: "A note", metadata: include("source" => "admin"))
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
