# frozen_string_literal: true

RSpec.describe "Query.controlledVocabulary", type: :request, graphql: true do
  let(:query) do
    <<~GRAPHQL
    query getRecords($kind: ControlledVocabularyKind!, $order: ControlledVocabularyRecordOrder, $visibility: Visibility, $used: Boolean, $nameSearch: SearchQueryInput) {
      controlledVocabulary(kind: $kind) {
        kind
        records(order: $order, visibility: $visibility, used: $used, nameSearch: $nameSearch) {
          nodes {
            __typename
            id
            name
            kind
            visibility
            description
            solutionDraftsCount
            canReplace { value }
            ... on License { url }
          }

          pageInfo {
            totalCount
          }
        }
      }
    }
    GRAPHQL
  end

  let_it_be(:alpha, refind: true) { FactoryBot.create :license, name: "Alpha License", description: "internal note", url: "https://example.org/alpha" }
  let_it_be(:bravo, refind: true) { FactoryBot.create :license, :hidden, name: "Bravo License" }

  let(:kind) { "LICENSE" }
  let(:order) { "NAME_ASCENDING" }
  let(:visibility) { nil }
  let(:used) { nil }
  let(:name_search) { nil }

  let(:graphql_variables) { { kind:, order:, visibility:, used:, name_search: }.compact }

  def nodes = graphql_response(:data, :controlledVocabulary, :records, :nodes)

  def names = nodes.pluck("name")

  as_an_anonymous_user do
    it "lists every record, hidden ones included, without admin details" do
      make_default_request!

      expect(names).to eq License.lazily_order(:name, :asc).pluck(:name)
      expect(nodes).to all(include("__typename" => "License", "kind" => "LICENSE", "description" => nil, "solutionDraftsCount" => nil))
      expect(nodes.find { _1["name"] == "Alpha License" }).to include("url" => "https://example.org/alpha")
      expect(nodes.map { _1.dig("canReplace", "value") }).to all(be false)
    end

    context "when filtering by visibility" do
      let(:visibility) { "HIDDEN" }

      it "returns only hidden records" do
        make_default_request!

        expect(names).to eq License.hidden.lazily_order(:name, :asc).pluck(:name)
      end
    end

    context "when searching by name" do
      let(:name_search) { { needle: "Bravo" } }

      it "returns matching records" do
        make_default_request!

        expect(names).to eq ["Bravo License"]
      end
    end

    context "when filtering to unused records" do
      let(:used) { false }

      it "returns only unused records" do
        make_default_request!

        expect(names).to include("Alpha License", "Bravo License")
      end
    end
  end

  as_an_admin_user do
    it "includes admin details and permissions" do
      make_default_request!

      expect(nodes.find { _1["name"] == "Alpha License" }).to include(
        "description" => "internal note", "solutionDraftsCount" => 0, "canReplace" => { "value" => true }
      )
    end
  end

  describe "every kind" do
    let(:current_user) { admin_user }

    Types::ControlledVocabularyKindType.values.each do |enum_name, enum_value|
      it "resolves #{enum_name}" do
        make_default_request!(variables: { kind: enum_name })

        expect(graphql_response(:data, :controlledVocabulary, :kind)).to eq enum_name
        expect(nodes).to all(include("__typename" => enum_value.value))
      end
    end
  end

  describe "looking up a record by id" do
    let(:query) { "query($id: ID!) { node(id: $id) { __typename ... on ControlledVocabularyRecord { name } ... on License { url } } }" }

    let(:graphql_variables) { { id: alpha.to_encoded_id } }

    it "finds it anonymously" do
      make_default_request!

      expect(graphql_response(:data, :node)).to eq("__typename" => "License", "name" => "Alpha License", "url" => "https://example.org/alpha")
    end
  end
end
