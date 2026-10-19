# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ViewerUpdateNotifications
  class ViewerUpdateNotifications < Mutations::BaseMutation
    description <<~TEXT
    Choose which email notifications the current user receives.
    TEXT

    field :user, Types::UserType, null: true do
      description "The viewer, after updating their preferences."
    end

    argument :comment_notifications, Types::SubscriptionType, required: false do
      description "Whether to be emailed about comments."
    end

    argument :solution_notifications, Types::SubscriptionType, required: false do
      description "Whether to be emailed about solution workflow changes."
    end

    performs_operation! "mutations.implementations.viewer_update_notifications"
  end
end
