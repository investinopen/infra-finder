# frozen_string_literal: true

# @see SolutionImport
class SolutionImportPolicy < ApplicationPolicy
  def index?
    has_any_admin_access?
  end

  def show?
    has_any_admin_access?
  end

  def create?
    has_any_admin_access?
  end

  def update?
    has_any_admin_access?
  end

  def destroy?
    has_any_admin_access?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
