# frozen_string_literal: true

RSpec.describe "Provider.assignableUsers", type: :request, graphql: true do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:candidate, refind: true) { FactoryBot.create :user }

  let_it_be(:assigned, refind: true) { FactoryBot.create(:user).tap { provider.assign_editor!(_1) } }

  let(:query) do
    <<~GRAPHQL
    query($slug: Slug!) {
      provider(slug: $slug) {
        assignableUsers(perPage: 200) { nodes { email } }
      }
    }
    GRAPHQL
  end

  def emails
    graphql_response(:data, :provider, :assignableUsers, :nodes).pluck("email")
  end

  before do
    make_graphql_request! query, token:, variables: { slug: provider.system_slug }, operation: nil
  end

  as_an_admin_user do
    it "lists users who are neither admins nor already its editors" do
      expect(emails).to include(candidate.email)
      expect(emails).not_to include(assigned.email, admin_user.email)
    end
  end

  as_an_editor_user do
    it "lists nothing" do
      expect(emails).to be_empty
    end
  end
end
