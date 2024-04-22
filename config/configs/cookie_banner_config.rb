# frozen_string_literal: true

class CookieBannerConfig < ApplicationConfig
  config_name :cookie_banner

  attr_config enabled: false

  coerce_types enabled: :boolean
end
