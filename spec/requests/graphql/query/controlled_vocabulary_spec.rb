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

  before_all do
    ControlledVocabularies::SyncEntriesJob.perform_now
  end

  let(:kind) { "LICENSE" }
  let(:order) { "NAME_ASCENDING" }
  let(:visibility) { nil }
  let(:used) { nil }
  let(:name_search) { nil }

  let(:graphql_variables) { { kind:, order:, visibility:, used:, name_search: }.compact }

  let(:sorted_records) { License.lazily_order(:name, :asc).to_a }

  let(:admin_details) { false }

  let(:expected_shape) do
    gql.query do |q|
      q.prop :controlled_vocabulary do |cv|
        cv[:kind] = "LICENSE"

        cv.prop :records do |r|
          r.array :nodes do |nodes|
            sorted_records.each do |record|
              nodes.item do |n|
                n.typename "License"
                n[:id] = record.to_encoded_id
                n[:name] = record.name
                n[:kind] = "LICENSE"
                n[:visibility] = Types::VisibilityType.name_for_value(record.visibility)
                n[:description] = admin_details ? record.description : nil
                n[:solution_drafts_count] = admin_details ? record.solution_drafts_count : nil
                n[:url] = record.url

                n.prop :can_replace do |cr|
                  cr[:value] = admin_details
                end
              end
            end
          end

          r.prop :page_info do |pi|
            pi[:total_count] = sorted_records.size
          end
        end
      end
    end
  end

  shared_examples "a license listing" do
    it "lists the expected records" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    let(:admin_details) { true }

    include_examples "a license listing"
  end

  as_an_anonymous_user do
    context "with no filters" do
      include_examples "a license listing"
    end

    context "when filtering by visibility" do
      let(:visibility) { "HIDDEN" }

      let(:sorted_records) { License.hidden.lazily_order(:name, :asc).to_a }

      include_examples "a license listing"
    end

    context "when searching by name" do
      let(:name_search) { { needle: "Bravo" } }

      let(:sorted_records) { [bravo] }

      include_examples "a license listing"
    end

    context "when filtering to unused records" do
      let(:used) { false }

      let(:sorted_records) { License.unused.lazily_order(:name, :asc).to_a }

      include_examples "a license listing"
    end
  end

  describe "every kind" do
    before_all do
      InfraFinder::Container["controlled_vocabularies.upsert_all_records"].().value!
    end

    let(:current_user) { admin_user }

    let(:query) do
      <<~GRAPHQL
      query getVocabularyWithRecord($kind: ControlledVocabularyKind!, $urlSlug: String!) {
        controlledVocabulary(kind: $kind) {
          kind

          records(order: NAME_ASCENDING) {
            nodes {
              __typename
              id
            }

            pageInfo {
              totalCount
            }
          }

          record(urlSlug: $urlSlug) {
            __typename
            id
            urlSlug
          }
        }
      }
      GRAPHQL
    end

    let(:graphql_variables) { { kind:, url_slug: existing_slug } }

    let(:records) { model_klass.lazily_order(:name, :asc).to_a }

    let(:existing_record) { model_klass.find_by!(slug: existing_slug) }

    let(:kind_shape) do
      gql.query do |q|
        q.prop :controlled_vocabulary do |cv|
          cv[:kind] = kind

          cv.prop :records do |r|
            r.array :nodes do |nodes|
              records.each do |record|
                nodes.item do |n|
                  n.typename model_klass.name
                  n[:id] = record.to_encoded_id
                end
              end
            end

            r.prop :page_info do |pi|
              pi[:total_count] = records.size
            end
          end

          cv.prop :record do |rec|
            rec.typename model_klass.name
            rec[:id] = existing_record.to_encoded_id
            rec[:url_slug] = existing_slug
          end
        end
      end
    end

    where(:case_name, :kind, :model_klass) do
      ControlledVocabulary.with_model_name.map do |vocab|
        kind = Types::ControlledVocabularyKindType.name_for_value(vocab.kind)

        [kind, kind, vocab.model_klass]
      end
    end

    with_them do
      # Records only exist once `before_all` has upserted them, so this can't live in the table.
      let(:existing_slug) { records.first.slug }

      it "resolves the vocabulary, its records, and a record by slug" do
        expect_request! do |req|
          req.data! kind_shape
        end
      end
    end
  end

  describe "looking up a record by id" do
    let(:query) do
      <<~GRAPHQL
      query getNode($id: ID!) {
        node(id: $id) {
          __typename

          ... on ControlledVocabularyRecord {
            name
          }

          ... on License {
            url
          }
        }
      }
      GRAPHQL
    end

    let(:graphql_variables) { { id: alpha.to_encoded_id } }

    let(:node_shape) do
      gql.query do |q|
        q.prop :node do |n|
          n.typename "License"
          n[:name] = "Alpha License"
          n[:url] = "https://example.org/alpha"
        end
      end
    end

    it "finds it anonymously" do
      expect_request! do |req|
        req.data! node_shape
      end
    end
  end
end
