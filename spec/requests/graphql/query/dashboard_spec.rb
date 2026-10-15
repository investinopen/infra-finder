# frozen_string_literal: true

# The queries behind the admin dashboard's panels.
RSpec.describe "Dashboard queries", type: :request, graphql: true do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:own_solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:reviewed_solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:other_solution, refind: true) { FactoryBot.create(:solution).tap(&:published!) }

  let_it_be(:older_pending, refind: true) { own_solution.create_draft!(user: editor).tap { _1.update_columns(updated_at: 2.days.ago) } }

  let_it_be(:newer_pending, refind: true) { other_solution.create_draft!(user: FactoryBot.create(:user)) }

  let_it_be(:in_review, refind: true) { reviewed_solution.create_draft!(user: editor).tap(&:request_review!) }

  let(:query) do
    <<~GRAPHQL
    query {
      inReview: solutionDrafts(filters: { inState: [IN_REVIEW] }, order: RECENT_UPDATES, perPage: 25) { nodes { identifier } }
      pending: solutionDrafts(filters: { inState: [PENDING] }, order: RECENT_UPDATES, perPage: 25) { nodes { identifier } }
      mine: solutions(filters: { editableByViewer: true }, order: RECENT_UPDATES, perPage: 25) { nodes { name } }
    }
    GRAPHQL
  end

  def panel(name, key = "identifier")
    graphql_response(:data, name, :nodes).pluck(key)
  end

  before { make_graphql_request! query, token:, operation: nil }

  as_an_admin_user do
    it "shows every draft, most recently updated first" do
      expect(panel(:inReview)).to eq [in_review.identifier]
      expect(panel(:pending)).to eq [newer_pending.identifier, older_pending.identifier]
    end
  end

  context "as an editor" do
    let(:current_user) { editor }

    it "shows their own drafts and solutions" do
      expect(panel(:inReview)).to eq [in_review.identifier]
      expect(panel(:pending)).to eq [older_pending.identifier]
      expect(panel(:mine, "name")).to contain_exactly(own_solution.name, reviewed_solution.name)
    end
  end
end
