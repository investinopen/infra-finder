# frozen_string_literal: true

# Builds the links in authentication emails.
#
# They point at the admin SPA when {LocationsConfig#admin_spa?} is set, and
# otherwise fall back to the URL from the block (the Devise HTML pages).
module AuthLinks
  class << self
    # @param [String] token
    # @yieldreturn [String] the Devise URL
    # @return [String]
    def confirmation(token, &) = link_for("/confirm", token, &)

    # @param [String] token
    # @yieldreturn [String] the Devise URL
    # @return [String]
    def reset_password(token, &) = link_for("/reset-password", token, &)

    # @param [String] token
    # @yieldreturn [String] the Devise URL
    # @return [String]
    def unlock(token, &) = link_for("/unlock", token, &)

    private

    # @param [String] path the SPA path
    # @param [String] token
    # @yieldreturn [String] the Devise URL
    # @return [String]
    def link_for(path, token)
      if LocationsConfig.admin_spa?
        LocationsConfig.admin_spa_url(path, token:)
      else
        yield
      end
    end
  end
end
