# frozen_string_literal: true

# Configuration for the database-backed session store.
class SessionConfig < ApplicationConfig
  attr_config base_key: "_infra_sess", include_env_in_key: Rails.env.local?, ttl: 30

  coerce_types include_env_in_key: :boolean, ttl: :integer

  # @return [String]
  def domain
    root_uri.host
  end

  memoize def key
    [base_key, include_env_in_key && Rails.env.to_s].compact_blank.join(?_)
  end

  # @return [Boolean]
  def secure
    root_uri.scheme == "https"
  end

  alias secure? secure

  def to_session_store_options
    {
      domain:,
      expire_after: ttl.days,
      httponly: true,
      key:,
      same_site: :lax,
      secure:,
    }
  end

  private

  def root_uri
    @root_uri ||= URI(LocationsConfig.root)
  end
end
