# frozen_string_literal: true

RSpec.describe "Query.solutions", type: :request, graphql: true do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:own_unpublished, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:other_published, refind: true) { FactoryBot.create(:solution).tap(&:published!) }

  let_it_be(:other_unpublished, refind: true) { FactoryBot.create :solution }

  let(:filters) { {} }

  let(:query) do
    <<~GRAPHQL
    query($filters: SolutionFilterInput) {
      solutions(filters: $filters, perPage: 50) {
        nodes {
          name
          publication
          firstName
          provider { name }
          drafts(perPage: 5) { nodes { identifier } }
          revisions(perPage: 5) { nodes { kind } }
          canCreateDraft { value }
        }
      }
    }
    GRAPHQL
  end

  def names
    graphql_response(:data, :solutions, :nodes).pluck("name")
  end

  before do
    make_graphql_request! query, token:, variables: { filters: }, operation: nil
  end

  as_an_anonymous_user do
    it "lists only published solutions, without hidden values" do
      expect(names).to contain_exactly(other_published.name)

      expect(graphql_response(:data, :solutions, :nodes, 0)).to include(
        "publication" => nil, "firstName" => nil, "provider" => { "name" => other_published.provider.name }, "drafts" => { "nodes" => [] }
      )
    end
  end

  context "as an editor" do
    let(:current_user) { editor }

    it "lists published solutions and their own" do
      expect(names).to contain_exactly(other_published.name, own_unpublished.name)
    end

    context "when filtering to editable solutions" do
      let(:filters) { { editable_by_viewer: true } }

      it "lists only their own, which they can draft changes to" do
        expect(names).to contain_exactly(own_unpublished.name)

        expect(graphql_response(:data, :solutions, :nodes, 0)).to include("canCreateDraft" => { "value" => true })
      end
    end
  end

  as_an_admin_user do
    it "lists every solution, with hidden values" do
      expect(names).to include(own_unpublished.name, other_published.name, other_unpublished.name)

      expect(graphql_response(:data, :solutions, :nodes).pluck("publication")).to all(be_present)
    end

    context "when filtering by publication" do
      let(:filters) { { publication: ["UNPUBLISHED"] } }

      it "applies the filter" do
        expect(names).to include(own_unpublished.name, other_unpublished.name)
        expect(names).not_to include(other_published.name)
      end
    end
  end
end
