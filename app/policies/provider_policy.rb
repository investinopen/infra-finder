# frozen_string_literal: true

# @see Provider
class ProviderPolicy < ApplicationPolicy
  # Providers are named on the public site; listing them stays admin-only.
  #
  # @return [Boolean]
  def show? = true

  private

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    relation.where(id: Provider.with_editor_access_for(user).select(:id))
  end
end
