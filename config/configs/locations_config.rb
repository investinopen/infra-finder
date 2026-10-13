# frozen_string_literal: true

# Configuration for URL locations associated with this application
class LocationsConfig < ApplicationConfig
  include Support::Routing::Helper

  STANDARD_PORTS = [80, 443].freeze

  attr_config :root, :instructions

  # The base URL of the admin SPA. When set, auth emails link to the SPA
  # instead of the Devise HTML pages.
  attr_config :admin_spa

  # @see AuthLinks
  # @return [Boolean]
  def admin_spa? = admin_spa.present?

  # The CORS origin of the admin SPA, or `"*"` when none is configured.
  #
  # @return [String]
  def admin_spa_origin
    return "*" unless admin_spa?

    URI(admin_spa).origin
  end

  # Build a URL under {#admin_spa}, keeping any path it already has
  # (e.g. `https://example.org/admin` + `/confirm` => `https://example.org/admin/confirm`).
  #
  # @param [String] path
  # @param [{ Symbol => String }] query
  # @return [String]
  def admin_spa_url(path, **query)
    base = admin_spa.end_with?("/") ? admin_spa : "#{admin_spa}/"

    uri = URI.join(base, path.delete_prefix("/"))

    uri.query = query.to_query if query.any?

    uri.to_s
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
