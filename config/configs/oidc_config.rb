# frozen_string_literal: true

# Configuration for Infra Finder as an OpenID Provider.
class OidcConfig < ApplicationConfig
  # A PEM-encoded RSA private key that signs ID tokens.
  #
  # @see #signing_key_pem
  attr_config :signing_key

  # The admin SPA's `client_id`.
  #
  # @see OAuth::SyncApplications
  attr_config admin_spa_client_id: "infra-finder-admin-spa"

  # {#signing_key} with real newlines. Env files (Kamal's, and pasted App
  # Platform values) can only carry the PEM on one line, with literal `\n`s.
  #
  # It is read when a token is signed, not at boot, so tasks like asset
  # precompilation run without it.
  #
  # @return [String, nil]
  def signing_key_pem
    signing_key.presence&.gsub("\\n", "\n")
  end
end
