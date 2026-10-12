# frozen_string_literal: true

# @see ProviderEditorAssignment
class ProviderEditorAssignmentPolicy < ApplicationPolicy
  requires_admin_for_show!

  def create?
    has_any_admin_access?
  end
end
