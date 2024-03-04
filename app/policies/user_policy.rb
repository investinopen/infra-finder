# frozen_string_literal: true

# @see User
class UserPolicy < ApplicationPolicy
  def index?
    has_any_admin_access?
  end

  def show?
    has_any_admin_access? || user_matches?
  end

  private

  def user_matches?
    user == record
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
