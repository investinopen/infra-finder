# frozen_string_literal: true

RSpec.describe "SolutionRevision", type: :request, graphql: true do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  let_it_be(:revision, refind: true) do
    solution.initialize_revision!
    solution.update!(name: "Renamed")
    solution.create_revision!(kind: "direct")
    solution.solution_revisions.reload.first
  end

  let(:query) do
    <<~GRAPHQL
    query($id: ID!) {
      node(id: $id) {
        ... on SolutionRevision { kind diffsCount diffs { name verb property { key } oldValue newValue } }
      }
    }
    GRAPHQL
  end

  before { make_graphql_request! query, token:, variables: { id: revision.to_encoded_id }, operation: nil }

  as_an_anonymous_user do
    it "is hidden" do
      expect(graphql_response(:data, :node)).to be_nil
    end
  end

  as_an_admin_user do
    it "describes each change" do
      expect(graphql_response(:data, :node, :diffs)).to include(
        include("name" => "name", "verb" => "CHANGE", "property" => { "key" => "name" }, "newValue" => "Renamed")
      )
    end
  end
end
