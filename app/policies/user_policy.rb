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

  # In the API, admins see every user; everyone else sees only themselves.
  #
  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_api_scope(relation)
    return relation.all if has_any_admin_access?

    return relation.none unless authenticated?

    relation.where(id: user.id)
  end

  # @return [Boolean] false for `nil` and {AnonymousUser}
  def authenticated?
    user.present? && !user.anonymous?
  end

  def user_matches?
    user == record
  end
end
