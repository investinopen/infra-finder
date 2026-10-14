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

  # Whether a GraphQL API viewer may manage their own session
  # (sign out, refresh their token, accept terms).
  #
  # @return [Boolean]
  def manage_own_session?
    authenticated? && user_matches?
  end

  private

  def user_matches?
    user == record
  end
end
