# frozen_string_literal: true

# @deprecated
# @see SolutionEditorAssignment
class SolutionEditorAssignmentPolicy < ApplicationPolicy
  requires_admin_for_show!

  def create?
    has_any_admin_access?
  end
end
