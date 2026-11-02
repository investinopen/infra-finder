# frozen_string_literal: true

# Configuration for URL locations associated with this application
class LocationsConfig < ApplicationConfig
  include Support::Routing::Helper

  STANDARD_PORTS = [80, 443].freeze

  attr_config :root, :instructions

  attr_config local_admin: "http://localhost:3000"

  # The base URL of the admin SPA, an OpenID Connect client of this app.
  attr_config :admin_spa, allow_local_admin: false

  coerce_types allow_local_admin: :boolean

  memoize def admin_origins
    [].tap do |a|
      a << root_origin
      a << admin_spa_origin if admin_spa?
      a << local_admin_origin if allow_local_admin?
    end.uniq
  end

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

  def local_admin_origin = URI(local_admin).origin

  memoize def root_domain
    uri = URI(root)

    [uri.hostname].tap do |a|
      # simplecov:disable
      a << uri.port unless uri.port.in?(STANDARD_PORTS)
      # simplecov:enable
    end.join(?:)
  end

  def root_origin = URI(root).origin

  # @return [Hash]
  memoize def root_url_options
    url_options_for root
  end
end
