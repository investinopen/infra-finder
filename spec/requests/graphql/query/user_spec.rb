# frozen_string_literal: true

RSpec.describe "Query.user", type: :request, graphql: true do
  let(:query) do
    <<~GRAPHQL
    query getUser($slug: Slug!) {
      user(slug: $slug) {
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

  let(:found_shape) do
    gql.query do |q|
      q.prop :user do |m|
        m[:id] = existing_model.to_encoded_id
        m[:slug] = existing_model.system_slug

        m.auth_results(can_update:, can_destroy:)
      end
    end
  end

  let(:blank_shape) do
    gql.query do |q|
      q[:user] = be_blank
    end
  end

  let_it_be(:existing_model, refind: true) { FactoryBot.create :user }

  let(:slug) { existing_model.system_slug }

  let(:graphql_variables) do
    { slug:, }
  end

  shared_examples "a found record" do
    it "finds the User" do
      expect_request! do |req|
        req.data! found_shape
      end
    end
  end

  shared_examples "a not found record" do
    it "does not find the User" do
      expect_request! do |req|
        req.data! blank_shape
      end
    end
  end

  shared_examples "an existing model lookup" do
    context "when looking for an existing model by slug" do
      include_examples "a found record"
    end
  end

  shared_examples "an authorized lookup" do
    include_examples "an existing model lookup"

    context "when looking for an unknown model by slug" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end

  as_a_super_admin_user do
    let(:can_update) { true }
    let(:can_destroy) { true }

    include_examples "an authorized lookup"
  end

  as_an_admin_user do
    let(:can_update) { false }
    let(:can_destroy) { false }

    include_examples "an authorized lookup"
  end

  as_an_editor_user do
    include_examples "a not found record"

    context "when looking up themselves" do
      let(:existing_model) { current_user }

      include_examples "a found record"
    end
  end

  as_an_anonymous_user do
    include_examples "a not found record"
  end
end
