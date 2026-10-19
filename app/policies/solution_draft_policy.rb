# frozen_string_literal: true

# @see SolutionDraft
class SolutionDraftPolicy < ApplicationPolicy
  include Policies::HidesSolutionValues

  def index?
    admin_or_editor?
  end

  def show?
    admin_or_editor_for_record?
  end

  def update?
    record.mutable? && admin_or_editor_for_record?
  end

  def destroy?
    return super unless record.pending?

    admin_or_editor_for_record?
  end

  def request_review?
    update? && can_transition_to?(:in_review)
  end

  def request_revision?
    has_any_admin_access? && can_transition_to?(:pending)
  end

  def approve?
    has_any_admin_access? && can_transition_to?(:approved)
  end

  def reject?
    has_any_admin_access? && can_transition_to?(:rejected)
  end

  private

  # @param [Symbol] state
  # @return [Boolean]
  def can_transition_to?(state)
    record.try(:can_transition_to?, state)
  end

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_authenticated(relation)
    relation.where(solution_id: Solution.with_editor_access_for(user).select(:id))
  end
end
