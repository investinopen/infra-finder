# frozen_string_literal: true

module Users
  # For mutations wrapping Devise's token methods (`reset_password_by_token`,
  # `confirm_by_token`, `unlock_access_by_token`).
  #
  # Those methods return a {User} carrying errors keyed by attribute names that
  # match the mutation arguments, so they are reported as attribute errors
  # rather than VOG's default global "Problem persisting" errors.
  module ReportsDeviseErrors
    # @param [User] user
    # @raise [VOGMutations::Halting::Invalid] when the user has errors
    # @return [void]
    def check_devise_errors!(user)
      return if user.errors.none?

      graphql_response.mark_invalid!

      user.errors.each do |error|
        add_attribute_error! error.message, path: error.attribute
      end

      throw_invalid
    end
  end
end
