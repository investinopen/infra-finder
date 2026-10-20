# frozen_string_literal: true

# Configuration for URL locations associated with this application
class LocationsConfig < ApplicationConfig
  include Support::Routing::Helper

  STANDARD_PORTS = [80, 443].freeze

  attr_config :root, :instructions

  # The base URL of the admin SPA, an OpenID Connect client of this app.
  attr_config :admin_spa

  # @return [Boolean]
  def admin_spa? = admin_spa.present?

  # The SPA's redirect URI and post-logout redirect URI. oidc-spa uses its
  # home URL, with a trailing slash, for both.
  #
  # @see OAuth::SyncApplications
  # @return [String]
  def admin_spa_home_url
    admin_spa.end_with?("/") ? admin_spa : "#{admin_spa}/"
  end

  # The CORS origin of the admin SPA, or `"*"` when none is configured.
  #
  # @return [String]
  def admin_spa_origin
    return "*" unless admin_spa?

    URI(admin_spa).origin
  end

  memoize def root_domain
    uri = URI(root)

    [uri.hostname].tap do |a|
      # simplecov:disable
      a << uri.port unless uri.port.in?(STANDARD_PORTS)
      # simplecov:enable
    end.join(?:)
  end

  # @return [Hash]
  memoize def root_url_options
    url_options_for root
  end
end
