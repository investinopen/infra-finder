# frozen_string_literal: true

class MatomoConfig < ApplicationConfig
  attr_config :enabled, :site_id, :tag_manager_url

  coerce_types enabled: :boolean, site_id: :string, tag_manager_url: :string

  delegate :root_domain, to: LocationsConfig

  memoize def cookie_domain
    "*.#{root_domain}"
  end

  memoize def cookie_path
    "*.#{root_domain}"
  end

  memoize def domains
    [
      "*.#{root_domain}/solutions",
    ]
  end
end
