# frozen_string_literal: true

# @see Provider
class ProviderPolicy < ApplicationPolicy
  # @return [Boolean]
  def show?
    admin_or_editor_for_record?
  end
end
