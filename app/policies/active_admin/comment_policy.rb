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

    private

    # @param [ActiveRecord::Relation] relation
    # @return [ActiveRecord::Relation]
    # @param [ActiveRecord::Relation] relation
    # @return [ActiveRecord::Relation]
    def resolve_scope_for_authenticated(relation)
      editable_solutions = Solution.with_editor_access_for(user).select(:id)
      editable_drafts = SolutionDraft.where(solution_id: editable_solutions)

      base = ActiveAdmin::Comment.all.unscoped

      solution_comments = base.where(resource_type: "Solution", resource_id: editable_solutions)
      draft_comments = base.where(resource_type: "SolutionDraft", resource_id: editable_drafts)

      scoped = solution_comments.or(draft_comments)

      relation.merge(scoped)
    end
  end
end
