# frozen_string_literal: true

# @see Provider
class ProviderPolicy < ApplicationPolicy
  requires_admin_for_show!

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
