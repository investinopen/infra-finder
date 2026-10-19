# frozen_string_literal: true

RSpec.describe "Query.solutionIntakes", type: :request, graphql: true do
  let_it_be(:pending_intake, refind: true) { FactoryBot.create :solution_intake }

  let_it_be(:rejected_intake, refind: true) do
    FactoryBot.create(:solution_intake).tap do |intake|
      intake.transition_to!(:in_review)
      intake.transition_to!(:rejected)
    end
  end

  describe "the list" do
    let(:query) { "query { solutionIntakes(perPage: 50) { nodes { snowflake currentState } } }" }

    before { make_graphql_request! query, token:, operation: nil }

    as_an_anonymous_user do
      it "lists nothing" do
        expect(graphql_response(:data, :solutionIntakes, :nodes)).to be_empty
      end
    end

    as_an_editor_user do
      it "lists nothing" do
        expect(graphql_response(:data, :solutionIntakes, :nodes)).to be_empty
      end
    end

    as_an_admin_user do
      it "lists every intake" do
        expect(graphql_response(:data, :solutionIntakes, :nodes).pluck("snowflake")).to include(pending_intake.snowflake.to_s, rejected_intake.snowflake.to_s)
      end
    end
  end

  describe "a single intake" do
    let(:query) { "query($slug: Slug!) { solutionIntake(slug: $slug) { snowflake currentState firstName canSubmit { value } canReset { value } uploadToken } }" }

    def fetch(intake)
      make_graphql_request! query, token:, variables: { slug: intake.system_slug }, operation: nil

      graphql_response(:data, :solutionIntake)
    end

    as_an_anonymous_user do
      it "returns a pending intake, hidden values included" do
        expect(fetch(pending_intake)).to include(
          "currentState" => "PENDING",
          "firstName" => pending_intake.first_name,
          "canSubmit" => { "value" => true },
          "canReset" => { "value" => false },
          "uploadToken" => be_present
        )
      end

      it "does not return a rejected intake" do
        expect(fetch(rejected_intake)).to be_nil
      end
    end

    as_an_admin_user do
      it "returns a rejected intake" do
        expect(fetch(rejected_intake)).to include(
          "currentState" => "REJECTED",
          "canSubmit" => { "value" => false },
          "canReset" => { "value" => true },
          "uploadToken" => nil
        )
      end
    end
  end
end
