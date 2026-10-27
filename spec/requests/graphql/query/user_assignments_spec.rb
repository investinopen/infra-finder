# frozen_string_literal: true

RSpec.describe "User.assignedProviders and User.editorAssignments", type: :request, graphql: true do
  let_it_be(:other_provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:other_editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { other_provider.assign_editor!(_1) } }

  let(:fields) do
    <<~GRAPHQL
    assignedProviders { id }
    editorAssignments(perPage: 50) { nodes { id } }
    GRAPHQL
  end

  def provider_ids(*path)
    graphql_response(:data, *path, :assignedProviders).pluck("id")
  end

  def assignment_ids(*path)
    graphql_response(:data, *path, :editorAssignments, :nodes).pluck("id")
  end

  context "when querying the viewer" do
    let(:query) do
      <<~GRAPHQL
      query { viewer { #{fields} } }
      GRAPHQL
    end

    before do
      make_graphql_request! query, token:, operation: nil
    end

    as_an_editor_user do
      it "lists the viewer's own providers and assignments" do
        expect(provider_ids(:viewer)).to match_array(editor_user.assigned_providers.map(&:to_encoded_id))
        expect(assignment_ids(:viewer)).to match_array(editor_user.provider_editor_assignments.map(&:to_encoded_id))
      end
    end

    as_an_admin_user do
      it "lists nothing" do
        expect(provider_ids(:viewer)).to be_empty
        expect(assignment_ids(:viewer)).to be_empty
      end
    end
  end

  context "when querying another user" do
    let(:query) do
      <<~GRAPHQL
      query($slug: Slug!) { user(slug: $slug) { #{fields} } }
      GRAPHQL
    end

    before do
      make_graphql_request! query, token:, variables: { slug: other_editor.system_slug }, operation: nil
    end

    as_an_admin_user do
      it "lists that user's providers and assignments" do
        expect(provider_ids(:user)).to contain_exactly(other_provider.to_encoded_id)
        expect(assignment_ids(:user)).to match_array(other_editor.provider_editor_assignments.map(&:to_encoded_id))
      end
    end
  end
end
