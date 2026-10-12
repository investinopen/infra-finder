# frozen_string_literal: true

# @see Solution
class SolutionPolicy < ApplicationPolicy
  def index?
    admin_or_editor?
  end

  def create?
    has_any_admin_access?
  end

  def update?
    has_any_admin_access?
  end

  def fetch_public?
    has_any_admin_access?
  end

  def create_draft?
    admin_or_editor_for_record?
  end

  def publish_all?
    has_any_admin_access?
  end

  def unpublish_all?
    has_any_admin_access?
  end

  private

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope(relation)
    return relation.all if has_any_admin_access?

    return relation.none unless has_any_editor_access?

    relation.with_editor_access_for(user)
  end
end
