# frozen_string_literal: true

# Configuration for URL locations associated with this application
class LocationsConfig < ApplicationConfig
  include Support::Routing::Helper

  STANDARD_PORTS = [80, 443].freeze

  attr_config root: "http://localhost:6856"

  memoize def root_domain
    uri = URI(root)

    [uri.hostname].tap do |a|
      # :nocov:
      a << uri.port unless uri.port.in?(STANDARD_PORTS)
      # :nocov:
    end.join(?:)
  end

  # @return [Hash]
  memoize def root_url_options
    url_options_for root
  end
end
