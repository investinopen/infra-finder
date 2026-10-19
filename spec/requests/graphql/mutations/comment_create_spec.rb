# frozen_string_literal: true

RSpec.describe Mutations::CommentCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation CommentCreate($input: CommentCreateInput!) {
    commentCreate(input: $input) {
      comment {
        body
        author { email }
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:editor, refind: true) { FactoryBot.create(:user, :accepted_terms).tap { provider.assign_editor!(_1) } }

  let_it_be(:solution, refind: true) { FactoryBot.create :solution, provider: }

  let_it_be(:subscriber, refind: true) { FactoryBot.create :user, :with_admin, :subscribed_to_all }

  let(:commentable) { solution }

  let_mutation_input!(:commentable_id) { commentable.to_encoded_id }
  let_mutation_input!(:body) { "A comment" }

  let(:empty_mutation_shape) { gql.empty_mutation :comment_create }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  shared_examples_for "an authorized mutation" do
    it "comments and notifies subscribers" do
      expected_shape = gql.mutation(:comment_create) do |m|
        m.prop(:comment) do |c|
          c[:body] = "A comment"
          c.prop(:author) { |a| a[:email] = current_user.email }
        end
      end

      expect_request! do |req|
        req.effect! change(Comment, :count).by(1).and have_enqueued_mail(CommentNotificationsMailer, :created).with(params: hash_including(recipient: subscriber), args: [])

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    include_examples "an authorized mutation"

    context "when commenting on a provider" do
      let(:commentable) { provider }

      it "comments" do
        expect_request! do |req|
          req.effect! change(Comment, :count).by(1)

          req.data! gql.mutation(:comment_create) { |m| m.prop(:comment) { |c| c[:body] = "A comment" } }
        end
      end
    end

    context "with a blank body" do
      let_mutation_input!(:body) { "" }

      it "fails validation" do
        expected_shape = gql.mutation(:comment_create, no_errors: false) do |m|
          m[:comment] = be_blank

          m.attribute_errors do |ae|
            ae.error :body, :filled?
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(Comment, :count)

          req.data! expected_shape
        end
      end
    end
  end

  context "as the solution's editor" do
    let(:current_user) { editor }

    include_examples "an authorized mutation"

    context "when commenting on the provider" do
      let(:commentable) { provider }

      include_examples "an unauthorized mutation"
    end
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
