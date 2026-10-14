# frozen_string_literal: true

# @see Solution
class SolutionPolicy < ApplicationPolicy
  include Policies::HidesSolutionValues

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

  # Published solutions are public, but their hidden values are for admins and editors.
  #
  # @return [Boolean]
  def show_hidden?
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
  def resolve_scope_for_anonymous(relation)
    relation.published
  end

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    relation.published.or(relation.where(id: Solution.with_editor_access_for(user).select(:id)))
  end
end
