# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ViewerUpdate
    class ViewerUpdate < VOGMutations::Implementation
      use_contract! :viewer_update

      authorizes! :current_user, with: :manage_own_session?

      # @param [Users::PrivilegedDataChange] privileged_data_change
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(privileged_data_change:, **attrs)
        assign_attributes!(current_user, **attrs)

        persist_model! current_user, attach_to: :user
      end

      # @return [void]
      before_prepare def check_privileged_data!
        args[:privileged_data_change] = Users::PrivilegedDataChange.new(current_user, **args)
      end
    end
  end
end
