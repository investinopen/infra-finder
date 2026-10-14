# frozen_string_literal: true

RSpec.describe "Query.solutionDrafts", type: :request, graphql: true do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:own_draft, refind: true) do
    solution.create_draft!(user: editor).tap { _1.update!(name: "Renamed", draft_overrides: %w[name]) }
  end

  let_it_be(:other_draft, refind: true) { FactoryBot.create(:solution).create_draft!(user: FactoryBot.create(:user)) }

  let(:query) do
    <<~GRAPHQL
    query {
      solutionDrafts(perPage: 50) {
        nodes {
          identifier
          name
          currentState
          solution { name }
          changedProperties { key fieldName }
          transitions(perPage: 5) { nodes { toState } }
        }
      }
    }
    GRAPHQL
  end

  def identifiers
    graphql_response(:data, :solutionDrafts, :nodes).pluck("identifier")
  end

  before do
    make_graphql_request! query, token:, operation: nil
  end

  as_an_anonymous_user do
    it "lists nothing" do
      expect(identifiers).to be_empty
    end
  end

  context "as an editor" do
    let(:current_user) { editor }

    it "lists drafts of their solutions, with the changed properties" do
      expect(identifiers).to contain_exactly(own_draft.identifier)

      expect(graphql_response(:data, :solutionDrafts, :nodes, 0)).to include(
        "name" => "Renamed",
        "currentState" => "PENDING",
        "solution" => { "name" => solution.name },
        "changedProperties" => [{ "key" => "name", "fieldName" => "name" }]
      )
    end
  end

  as_an_admin_user do
    it "lists every draft" do
      expect(identifiers).to include(own_draft.identifier, other_draft.identifier)
    end
  end
end
