# frozen_string_literal: true

# @see User
class UserPolicy < ApplicationPolicy
  def index?
    has_any_admin_access?
  end

  def show?
    has_any_admin_access? || user_matches?
  end

  def send_reset_password_instructions?
    user_matches? || has_any_admin_access?
  end

  private

  def user_matches?
    user == record
  end
end
