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

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
