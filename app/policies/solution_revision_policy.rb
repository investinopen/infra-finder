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
  def resolve_scope_for_authenticated(relation)
    relation.where(solution_id: Solution.with_editor_access_for(user).select(:id))
  end
end
