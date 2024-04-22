# frozen_string_literal: true

class CookieBannerComponent < ApplicationComponent
  # @return [CookieBannerConfig]
  attr_reader :config

  delegate :enabled?, to: :config

  # @param [MatomoConfig] config
  def initialize(config: CookieBannerConfig.__send__(:instance))
    @config = config
  end
end
