# frozen_string_literal: true

# @see Provider
class ProviderPolicy < ApplicationPolicy
  # Providers are named on the public site; listing them stays admin-only.
  #
  # @return [Boolean]
  def show? = true
end
