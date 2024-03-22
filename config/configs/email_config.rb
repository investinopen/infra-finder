# frozen_string_literal: true

class EmailConfig < ApplicationConfig
  attr_config origin: "do-not-reply@castironcoding.com"

  attr_config external: false

  attr_config :address, :port, :password, :username

  coerce_types external: :boolean, port: :integer

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
