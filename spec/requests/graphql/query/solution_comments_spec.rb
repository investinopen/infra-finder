# frozen_string_literal: true

RSpec.describe "Solution.comments", type: :request, graphql: true do
  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create(:solution, provider:).tap(&:published!) }

  let_it_be(:comment, refind: true) { Comment.create!(resource: solution, author: editor, body: "A comment") }

  let(:query) do
    <<~GRAPHQL
    query($slug: Slug!) {
      solution(slug: $slug) {
        canCreateComment
        comments { nodes { body author { email } } }
      }
    }
    GRAPHQL
  end

  def bodies
    graphql_response(:data, :solution, :comments, :nodes).pluck("body")
  end

  def can_create_comment
    graphql_response(:data, :solution, :canCreateComment)
  end

  before do
    make_graphql_request! query, token:, variables: { slug: solution.system_slug }, operation: nil
  end

  shared_examples_for "a commenter" do
    it "lists the comments and allows commenting" do
      expect(bodies).to eq ["A comment"]
      expect(can_create_comment).to be true
    end
  end

  shared_examples_for "an outsider" do
    it "lists nothing and refuses commenting" do
      expect(bodies).to be_empty
      expect(can_create_comment).to be false
    end
  end

  as_an_admin_user do
    include_examples "a commenter"
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "a commenter"
  end

  as_an_editor_user do
    include_examples "an outsider"
  end

  as_an_anonymous_user do
    include_examples "an outsider"
  end
end
