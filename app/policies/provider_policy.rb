# frozen_string_literal: true

# @see Provider
class ProviderPolicy < ApplicationPolicy
  requires_admin_for_show!
end
