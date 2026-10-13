# frozen_string_literal: true

RSpec.describe "Query.providers", type: :request, graphql: true do
  context "when ordering" do
    let(:query) do
      <<~GRAPHQL
      query getProviderCollection($order: ProviderOrder) {
        providers(order: $order) {
          edges {
            node {
              id
              slug

              canUpdate {
                ... AuthorizationResultFragment
              }

              canDestroy {
                ... AuthorizationResultFragment
              }
            }
          }

          pageInfo {
            totalCount
            totalUnfilteredCount
          }
        }
      }

      fragment AuthorizationResultFragment on AuthorizationResult {
        value
        message
        reasons {
          details
          fullMessages
        }
      }
      GRAPHQL
    end

    let(:can_update) { false }
    let(:can_destroy) { false }

    let(:expected_shape) do
      gql.query do |q|
        q.prop :providers do |c|
          c.array :edges do |edges|
            sorted_records.each do |r|
              edges.item do |edge|
                edge.prop :node do |n|
                  n[:id] = r.to_encoded_id
                  n[:slug] = r.system_slug

                  n.auth_results(can_update:, can_destroy:)
                end
              end
            end
          end

          c.prop :page_info do |pi|
            pi[:total_count] = sorted_records.size
            pi[:total_unfiltered_count] = sorted_records.size
          end
        end
      end
    end

    let(:graphql_variables) do
      { order:, }
    end

    let(:order) { "RECENT" }

    let_it_be(:records, refind: true) do
      %w[Delta Alpha Charlie Bravo].each_with_index.map do |name, n|
        attrs = {
          _at: (n + 1).days.ago,
          name:,
        }

        create_record(**attrs)
      end
    end

    # Includes the provider the shared editor user is assigned to.
    let(:sorted_records) { order_records(Provider.all.to_a, order:) }

    def create_record(_at:, **attrs)
      Timecop.freeze _at do
        FactoryBot.create(:provider, **attrs)
      end
    end

    # Name orders come from the database so that its collation decides,
    # rather than Ruby's byte order.
    def order_records(records, order: "RECENT")
      case order
      when "DEFAULT", "NAME_ASCENDING"
        return Provider.where(id: records.map(&:id)).lazily_order(:name, :asc).to_a
      when "NAME_DESCENDING"
        return Provider.where(id: records.map(&:id)).lazily_order(:name, :desc).to_a
      end

      records.sort_by do |record|
        case order
        when "OLDEST"
          [
            Put.asc(record.created_at),
          ]
        else
          # RECENT
          [
            Put.desc(record.created_at),
          ]
        end
      end
    end

    shared_examples_for "a properly-ordered collection" do
      it "retrieves everything in the right order" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    shared_examples_for "ordering by each option" do
      context "when ordering DEFAULT" do
        let(:order) { "DEFAULT" }

        include_examples "a properly-ordered collection"
      end

      context "when ordering RECENT" do
        let(:order) { "RECENT" }

        include_examples "a properly-ordered collection"
      end

      context "when ordering OLDEST" do
        let(:order) { "OLDEST" }

        include_examples "a properly-ordered collection"
      end

      context "when ordering NAME_ASCENDING" do
        let(:order) { "NAME_ASCENDING" }

        include_examples "a properly-ordered collection"
      end

      context "when ordering NAME_DESCENDING" do
        let(:order) { "NAME_DESCENDING" }

        include_examples "a properly-ordered collection"
      end
    end

    as_a_super_admin_user do
      let(:can_update) { true }
      let(:can_destroy) { true }

      include_examples "ordering by each option"
    end

    as_an_admin_user do
      let(:can_update) { false }
      let(:can_destroy) { false }

      include_examples "ordering by each option"
    end

    as_an_editor_user do
      let(:can_update) { false }
      let(:can_destroy) { false }

      let(:sorted_records) { [] }

      include_examples "ordering by each option"
    end

    as_an_anonymous_user do
      let(:can_update) { false }
      let(:can_destroy) { false }

      let(:sorted_records) { [] }

      include_examples "ordering by each option"
    end
  end
end
