# frozen_string_literal: true

# @see ProviderEditorAssignment
class ProviderEditorAssignmentPolicy < ApplicationPolicy
  def create?
    has_any_admin_access?
  end

  private

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    relation.where(user:)
  end
end
