# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    def index?
      has_any_admin_or_editor_access?
    end

    def show?
      has_any_admin_or_editor_access?
    end

    def create?
      has_any_admin_or_editor_access?
    end

    def destroy?
      has_any_admin_access? || record.author == user
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        return scope.all if has_any_admin_access?

        return scope.none unless has_any_editor_access?

        editable_solutions = Solution.with_editor_access_for(user).select(:id)
        editable_drafts = SolutionDraft.where(solution_id: editable_solutions)

        base = ActiveAdmin::Comment.all.unscoped

        solution_comments = base.where(resource_type: "Solution", resource_id: editable_solutions)
        draft_comments = base.where(resource_type: "SolutionDraft", resource_id: editable_drafts)

        scoped = solution_comments.or(draft_comments)

        scope.merge(scoped)
      end
    end
  end
end
