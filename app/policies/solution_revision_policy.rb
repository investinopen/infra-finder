# frozen_string_literal: true

# @see SolutionRevision
class SolutionRevisionPolicy < ApplicationPolicy
  def index?
    admin_or_editor?
  end

  def show?
    admin_or_editor_for_record?
  end

  class Scope < Scope
    def resolve
      return scope.all if has_any_admin_access?

      return scope.none unless has_any_editor_access?

      scope.where(solution_id: Solution.with_editor_access_for(user).select(:id))
    end
  end
end
