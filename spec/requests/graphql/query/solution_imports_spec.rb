# frozen_string_literal: true

RSpec.describe "Query.solutionImports", type: :request, graphql: true do
  let_it_be(:solution_import, refind: true) { FactoryBot.create :solution_import }

  let(:query) { "query { solutionImports(perPage: 50) { nodes { identifier strategy currentState messages { level message } } } }" }

  before { make_graphql_request! query, token:, operation: nil }

  as_an_editor_user do
    it "lists nothing" do
      expect(graphql_response(:data, :solutionImports, :nodes)).to be_empty
    end
  end

  as_an_admin_user do
    it "lists imports" do
      expect(graphql_response(:data, :solutionImports, :nodes)).to contain_exactly(
        include("identifier" => solution_import.identifier, "currentState" => "PENDING")
      )
    end
  end
end
