# frozen_string_literal: true

module Users
  # Rules for whether a {User} may hold a GraphQL API token.
  module Access
    class << self
      # Devise must allow the user to sign in (not locked, confirmed). Unassigned
      # users are allowed so the admin client can welcome them; policies decide
      # what they can do.
      #
      # @param [User] user
      # @return [Boolean]
      def allowed?(user)
        user.active_for_authentication?
      end
    end
  end
end
