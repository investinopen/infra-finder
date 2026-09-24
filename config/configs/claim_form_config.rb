# frozen_string_literal: true

class ClaimFormConfig < ApplicationConfig
  config_name :claim_form

  attr_config :url, enabled: false

  coerce_types enabled: :boolean, url: :string

  def available? = enabled? && url.present?

  # @todo Possibly pass id or other information to the URL in a query string.
  # @param [Solution] solution
  # @return [String, nil]
  def url_for(solution)
    return unless available?

    url
  end
end
