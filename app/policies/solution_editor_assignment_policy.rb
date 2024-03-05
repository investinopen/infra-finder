# frozen_string_literal: true

# @see SolutionEditorAssignment
class SolutionEditorAssignmentPolicy < ApplicationPolicy
  requires_admin_for_show!

  def create?
    has_any_admin_access?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
