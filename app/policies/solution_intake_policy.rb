# frozen_string_literal: true

# @see SolutionIntake
class SolutionIntakePolicy < ApplicationPolicy
  def index? = has_any_admin_access?

  def show? = allowed_for?(:pending, :in_review, must_be_mutable: false)

  def create? = has_any_admin_access?

  def edit? = allowed_for?(:pending, must_be_mutable: true)

  def update? = allowed_for?(:pending, must_be_mutable: true)

  # @!group Workflow Actions

  def approve? = has_any_admin_access? && can_transition_to?(:approved)

  def reject? = has_any_admin_access? && can_transition_to?(:rejected)

  def reset? = has_any_admin_access? && can_transition_to?(:pending)

  def submit? = allowed_for?(:pending, must_be_mutable: true) && can_transition_to?(:in_review)

  # @!endgroup Workflow Actions

  def approve_all? = has_any_admin_access?

  def reject_all? = has_any_admin_access?

  def batch_action?
    return approve_all? if record == :approve_all
    return reject_all? if record == :reject_all

    super
  end

  private

  def allowed_for?(*states, must_be_mutable: false)
    return true if record.in_state?(*states)

    return false if must_be_mutable && !record.mutable?

    has_any_admin_access?
  end

  def can_transition_to?(state)
    record.try(:can_transition_to?, state)
  end

  class Scope < Scope
    def resolve
      if has_any_admin_access?
        scope.all
      else
        scope.in_state(:pending, :in_review)
      end
    end
  end
end
