# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ViewerUpdateNotifications
    class ViewerUpdateNotifications < VOGMutations::Implementation
      use_contract! :viewer_update_notifications

      authorizes! :current_user, with: :manage_own_session?

      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(**attrs)
        user = current_user

        assign_attributes!(user, **attrs)

        persist_model! user, attach_to: :user
      end
    end
  end
end
