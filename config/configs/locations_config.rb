# frozen_string_literal: true

# Configuration for URL locations associated with this application
class LocationsConfig < ApplicationConfig
  include Support::Routing::Helper

  attr_config root: "http://localhost:6856"

  # @return [Hash]
  memoize def root_url_options
    url_options_for root
  end
end
