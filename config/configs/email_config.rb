# frozen_string_literal: true

class EmailConfig < ApplicationConfig
  attr_config origin: "do-not-reply@castironcoding.com"

  attr_config allowed_domains: Dry::Core::Constants::EMPTY_ARRAY,
    enabled: false, external: false

  attr_config :address, :allowed_domains, :port, :password, :username

  coerce_types enabled: :boolean, external: :boolean, port: :integer,
    allowed_domains: { type: :string, array: true }

  alias user_name username
  alias external? external

  # @return [Hash]
  memoize def smtp_settings
    if external?
      {
        user_name:,
        password:,
        address:,
        port:,
        authentication: :login,
        enable_starttls_auto: true,
      }
    else
      {
        address:,
        port:,
        enable_starttls_auto: true,
      }
    end
  end
end
