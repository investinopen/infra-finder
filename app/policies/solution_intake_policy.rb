# frozen_string_literal: true

# @see SolutionIntake
class SolutionIntakePolicy < ApplicationPolicy
  include Policies::HidesSolutionValues
  include Policies::Mutability

  pre_check :enforce_mutable!, only: %i[update submit]

  pre_check :require_any_admin!, only: %i[approve? reject? reset?]

  def index? = has_any_admin_access?

  def show? = any_admin_or_in_state?(:pending, :in_review)

  def create? = has_any_admin_access?

  def update? = mutable?

  alias_rule :edit?, to: :update?

  # @!group Workflow Actions

  def approve? = can_transition_to?(:approved)

  def reject? = can_transition_to?(:rejected)

  def reset? = can_transition_to?(:pending)

  def submit? = any_admin_or_in_state?(:pending) && can_transition_to?(:in_review)

  # @!endgroup Workflow Actions

  def approve_all? = has_any_admin_access?

  def reject_all? = has_any_admin_access?

  def batch_action?
    return approve_all? if record == :approve_all
    return reject_all? if record == :reject_all

    super
  end

  private

  # @param [<Symbol>] states
  def any_admin_or_in_state?(*states)
    return true if record.in_state?(*states)

    has_any_admin_access?
  end

  def calculate_mutable
    return false unless super

    record.pending? || has_any_admin_access?
  end
end
