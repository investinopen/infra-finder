# frozen_string_literal: true

# @see Comment
# @see ActiveAdmin::CommentPolicy
class CommentPolicy < ApplicationPolicy
  def index?
    has_any_admin_or_editor_access?
  end

  def show?
    record_exists_in_scope?
  end

  def create?
    has_any_admin_access? || has_editor_access_for_resource?
  end

  def destroy?
    has_any_admin_access? || record.author == user
  end

  private

  # Editors may comment only on the solutions and drafts they can see comments on.
  #
  # @see #resolve_scope_for_authenticated
  # @return [Boolean]
  def has_editor_access_for_resource?
    case record.resource
    when Solution, SolutionDraft
      has_role?(:editor, record.resource.provider)
    else
      false
    end
  end

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    editable_solutions = Solution.with_editor_access_for(user).select(:id)
    editable_drafts = SolutionDraft.where(solution_id: editable_solutions).select(:id)

    solution_comments = relation.where(resource_type: "Solution", resource_id: editable_solutions)
    draft_comments = relation.where(resource_type: "SolutionDraft", resource_id: editable_drafts)

    solution_comments.or(draft_comments)
  end
end
