# frozen_string_literal: true

# An issued GraphQL API token for a {User}. A token is valid only while its row exists.
#
# @see Devise::JWT::RevocationStrategies::Allowlist
class AllowlistedJwt < ApplicationRecord
  belongs_to :user, inverse_of: :allowlisted_jwts

  scope :expired, -> { where(exp: ...Time.current) }
end
