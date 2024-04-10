# frozen_string_literal: true

# @see SolutionDraft
class SolutionDraftPolicy < ApplicationPolicy
  def index?
    admin_or_editor?
  end

  def show?
    admin_or_editor_for_record?
  end

  def update?
    record.mutable? && admin_or_editor_for_record?
  end

  def destroy?
    return super unless record.pending?

    admin_or_editor_for_record?
  end

  def request_review?
    update?
  end

  def request_revision?
    has_any_admin_access?
  end

  def approve?
    has_any_admin_access?
  end

  def reject?
    has_any_admin_access?
  end

  class Scope < Scope
    def resolve
      return scope.all if has_any_admin_access?

      return scope.none unless has_any_editor_access?

      scope.where(solution_id: Solution.with_editor_access_for(user).select(:id))
    end
  end
end
