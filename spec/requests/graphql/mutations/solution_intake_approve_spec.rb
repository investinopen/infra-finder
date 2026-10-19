# frozen_string_literal: true

RSpec.describe Mutations::SolutionIntakeApprove, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation SolutionIntakeApprove($input: SolutionIntakeApproveInput!) {
    solutionIntakeApprove(input: $input) {
      solutionIntake {
        currentState
        solution {
          name
        }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:solution_intake, refind: true) do
    FactoryBot.create(:solution_intake, :notifiable, **complete_solution_attributes(:intake)).tap { _1.transition_to!(:in_review) }
  end

  let_mutation_input!(:solution_intake_id) { solution_intake.to_encoded_id }
  let_mutation_input!(:note) { "A note" }

  let(:empty_mutation_shape) { gql.empty_mutation :solution_intake_approve }

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
    it "approves the intake and creates its solution" do
      expected_shape = gql.mutation(:solution_intake_approve) do |m|
        m.prop(:solution_intake) do |i|
          i[:current_state] = "APPROVED"
          i.prop(:solution) { |s| s[:name] = solution_intake.name }
        end
      end

      expect_request! do |req|
        req.effect! change { solution_intake.current_state(force_reload: true) }.from("in_review").to("approved")
          .and change(Solution, :count).by(1)

        req.data! expected_shape
      end

      expect(solution_intake.last_transition).to have_attributes(note: "A note", metadata: include("source" => "admin"))
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"

    context "when the intake has no provider" do
      before { solution_intake.update!(provider: nil) }

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
