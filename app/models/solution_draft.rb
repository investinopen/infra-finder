# frozen_string_literal: true

# A draft of a {Solution} created by a {User}, to be reviewed by an administrator.
#
# @see SolutionDrafts::StateMachine
# @see SolutionDraftTransition
class SolutionDraft < ApplicationRecord
  include SolutionInterface
  include TimestampScopes
  include UsesStatesman

  has_state_machine! predicates: :ALL

  define_common_attributes!

  clear_exposed_ransackable_attributes!

  ransackable_minimum_allowance! :editor

  expose_ransackable_associations! :user, on: :editor

  expose_ransackable_attributes! :solution_id, :user_id, on: :editor

  belongs_to :solution, inverse_of: :solution_drafts, optional: true
  belongs_to :user, inverse_of: :solution_drafts, optional: true

  has_one :provider, through: :solution

  scope :mutable, -> { in_state(:pending, :in_review) }

  scope :pending, -> { in_state(:pending) }
  scope :in_review, -> { in_state(:in_review) }
  scope :approved, -> { in_state(:approved) }
  scope :rejected, -> { in_state(:rejected) }

  after_save :check!, if: :should_check?

  # @!group Stateful Workflow Methods

  monadic_matcher! def approve
    call_operation("solution_drafts.approve", self)
  end

  monadic_matcher! def reject
    call_operation("solution_drafts.reject", self)
  end

  monadic_matcher! def request_review
    call_operation("solution_drafts.request_review", self)
  end

  monadic_matcher! def request_revision
    call_operation("solution_drafts.request_revision", self)
  end

  # @!endgroup

  # @see SolutionDrafts::Check
  monadic_operation! def check
    call_operation("solution_drafts.check", self)
  end

  # @see SolutionDrafts::FetchChangedFields
  monadic_operation! def fetch_changed_fields
    call_operation("solution_drafts.fetch_changed_fields", self)
  end

  def finalized?
    in_state?(:approved, :rejected)
  end

  def mutable?
    in_state?(:pending, :in_review)
  end

  def pending_logo_change?
    in_state?(:pending, :in_review) && "logo".in?(draft_overrides)
  end

  # @return [<SolutionDrafts::ChangedField>]
  def changed_fields
    fetch_changed_fields.value_or([])
  end

  def should_check?
    TO_CLONE.any? do |attr|
      case attr
      when *ATTACHMENTS
        saved_change_to_attribute? :"#{attr}_data"
      else
        saved_change_to_attribute? attr
      end
    end
  end
end
