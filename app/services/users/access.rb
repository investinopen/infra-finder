# frozen_string_literal: true

module Users
  # Rules for whether a {User} may hold a GraphQL API token.
  module Access
    class << self
      # Devise must allow the user to sign in (not locked, confirmed), and the
      # user must have admin or editor access. Unassigned users are turned away,
      # matching ActiveAdmin.
      #
      # @param [User] user
      # @return [Boolean]
      def allowed?(user)
        user.active_for_authentication? && user.has_any_admin_or_editor_access?
      end
    end
  end
end
