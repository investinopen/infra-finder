# frozen_string_literal: true

class MatomoComponent < ApplicationComponent
  # @return [MatomoConfig]
  attr_reader :config

  delegate :enabled?, to: :config
  delegate :cookie_domain, :cookie_path, :domains, :site_id, :tag_manager_url, to: :config, prefix: :raw

  # @return [ActiveSupport::SafeBuffer]
  attr_reader :cookie_domain

  # @return [ActiveSupport::SafeBuffer]
  attr_reader :cookie_path

  # @return [ActiveSupport::SafeBuffer]
  attr_reader :domains

  # @return [ActiveSupport::SafeBuffer]
  attr_reader :site_id

  # @return [ActiveSupport::SafeBuffer]
  attr_reader :tag_manager_url

  # @param [MatomoConfig] config
  def initialize(config: MatomoConfig.__send__(:instance))
    @config = config

    @cookie_domain = for_js raw_cookie_domain
    @cookie_path = for_js raw_cookie_path
    @domains = for_js raw_domains
    @site_id = for_js raw_site_id
    @tag_manager_url = for_js raw_tag_manager_url
  end

  private

  # @param [Object] value
  # @return [ActiveSupport::SafeBuffer]
  def for_js(value)
    value.to_json.html_safe
  end
end
