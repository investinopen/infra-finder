# frozen_string_literal: true

# Doorkeeper models for Infra Finder as an OpenID Provider.
module OAuth
  # @return [String]
  def self.table_name_prefix = "oauth_"
end
