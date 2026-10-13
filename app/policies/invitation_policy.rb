# frozen_string_literal: true

# @see Invitation
class InvitationPolicy < ApplicationPolicy
  requires_admin_for_show!

  def index?
    has_any_admin_access?
  end

  def create?
    has_any_admin_access?
  end

  def destroy?
    has_any_admin_access?
  end
end
