# frozen_string_literal: true

RSpec.describe "Query.users", type: :request, graphql: true do
  context "when ordering" do
    let(:query) do
      <<~GRAPHQL
      query getUserCollection($order: UserOrder) {
        users(order: $order) {
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
        q.prop :users do |c|
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
      [["Delta", 2], ["Alpha", nil], ["Charlie", 3], ["Bravo", 1]].each_with_index.map do |(name, signed_in_hours_ago), n|
        current_sign_in_at = signed_in_hours_ago&.hours&.ago

        create_record(_at: (n + 1).days.ago, name:, email: "#{name.downcase}@example.org", current_sign_in_at:)
      end
    end

    # Includes the users from the shared GraphQL context.
    let(:sorted_records) { order_records(User.all.to_a, order:) }

    def create_record(_at:, **attrs)
      Timecop.freeze _at do
        FactoryBot.create(:user, **attrs)
      end
    end

    # Text orders come from the database so that its collation (case, accents)
    # decides, rather than Ruby's byte order.
    def order_records(records, order: "RECENT")
      ids = records.map(&:id)

      case order
      when "DEFAULT", "NAME_ASCENDING"
        User.where(id: ids).lazily_order(:name, :asc).to_a
      when "NAME_DESCENDING"
        User.where(id: ids).lazily_order(:name, :desc).to_a
      when "EMAIL_ASCENDING"
        User.where(id: ids).lazily_order(:email, :asc).to_a
      when "EMAIL_DESCENDING"
        User.where(id: ids).lazily_order(:email, :desc).to_a
      when "RECENT_SIGN_IN", "OLDEST_SIGN_IN"
        signed_in, never_signed_in = records.partition(&:current_sign_in_at)

        signed_in = signed_in.sort_by { _1.current_sign_in_at }
        signed_in.reverse! if order == "RECENT_SIGN_IN"

        signed_in + User.where(id: never_signed_in.map(&:id)).lazily_order(:name, :asc).to_a
      when "OLDEST"
        records.sort_by { Put.asc(_1.created_at) }
      else
        records.sort_by { Put.desc(_1.created_at) }
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

      %w[NAME_ASCENDING NAME_DESCENDING EMAIL_ASCENDING EMAIL_DESCENDING RECENT_SIGN_IN OLDEST_SIGN_IN].each do |option|
        context "when ordering #{option}" do
          let(:order) { option }

          include_examples "a properly-ordered collection"
        end
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
