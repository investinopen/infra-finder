# frozen_string_literal: true

# @see SolutionDraft
class SolutionDraftPolicy < ApplicationPolicy
  include Policies::HidesSolutionValues
  include Policies::Mutability

  pre_check :require_any_admin!, only: %i[request_revision? approve? reject?]

  def index? = admin_or_editor?

  def show? = admin_or_editor_for_record?

  def update? = mutable?

  alias_rule :edit?, to: :update?

  def destroy?
    return super unless record.pending?

    admin_or_editor_for_record?
  end

  def request_review? = update? && can_transition_to?(:in_review)

  def request_revision? = can_transition_to?(:pending)

  def approve? = can_transition_to?(:approved)

  def reject? = can_transition_to?(:rejected)

  private

  def calculate_mutable
    return false unless super

    return true if record.pending? && admin_or_editor_for_record?

    has_any_admin_access?
  end

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    relation.where(solution_id: Solution.with_editor_access_for(user).select(:id))
  end
end
