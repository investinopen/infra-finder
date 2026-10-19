# frozen_string_literal: true

RSpec.describe Mutations::ViewerUpdateNotifications, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ViewerUpdateNotifications($input: ViewerUpdateNotificationsInput!) {
    viewerUpdateNotifications(input: $input) {
      user {
        commentNotifications
        solutionNotifications
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_mutation_input!(:solution_notifications) { "SUBSCRIBED" }

  let(:empty_mutation_shape) { gql.empty_mutation :viewer_update_notifications }

  as_an_editor_user do
    it "updates the viewer's preferences" do
      expected_shape = gql.mutation(:viewer_update_notifications) do |m|
        m.prop(:user) do |u|
          u[:comment_notifications] = "UNSUBSCRIBED"
          u[:solution_notifications] = "SUBSCRIBED"
        end
      end

      expect_request! do |req|
        req.effect! change { editor_user.reload.solution_notifications }.from("unsubscribed").to("subscribed")

        req.data! expected_shape
      end
    end
  end

  as_an_anonymous_user do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end
end
