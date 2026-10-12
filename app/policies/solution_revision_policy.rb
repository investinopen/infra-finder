# frozen_string_literal: true

# @see SolutionRevision
class SolutionRevisionPolicy < ApplicationPolicy
  def index?
    admin_or_editor?
  end

  def show?
    admin_or_editor_for_record?
  end

  private

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope(relation)
    return relation.all if has_any_admin_access?

    return relation.none unless has_any_editor_access?

    relation.where(solution_id: Solution.with_editor_access_for(user).select(:id))
  end
end
