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

  def create_draft?
    admin_or_editor_for_record?
  end

  def publish_all?
    has_any_admin_access?
  end

  def unpublish_all?
    has_any_admin_access?
  end

  def batch_action?
    return publish_all? if record == :publish_all
    return unpublish_all? if record == :unpublish_all

    super
  end

  class Scope < Scope
    def resolve
      return scope.all if has_any_admin_access?

      return scope.none unless has_any_editor_access?

      scope.with_editor_access_for(user)
    end
  end
end
