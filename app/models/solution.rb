# frozen_string_literal: true

# The primary content model for this application.
class Solution < ApplicationRecord
  include SolutionInterface
  include SluggedByName
  include TimestampScopes

  resourcify

  belongs_to :provider, inverse_of: :solutions, counter_cache: true, touch: true

  has_many :comparison_items, inverse_of: :solution, dependent: :destroy
  has_many :solution_drafts, -> { in_recent_order }, inverse_of: :solution, dependent: :destroy
  has_many :solution_editor_assignments, inverse_of: :solution, dependent: :destroy

  define_common_attributes!
  expose_ransackable_associations! :solution_drafts
  expose_ransackable_attributes! :provider_id
  expose_ransackable_scopes! :with_pending_drafts, :with_reviewable_drafts

  delegate :name, to: :provider, prefix: true

  scope :with_editor_access_for, ->(user) { where(id: SolutionEditorAssignment.where(user:).select(:solution_id)) }
  scope :with_pending_drafts, -> { where(id: SolutionDraft.in_state(:pending).select(:solution_id)) }
  scope :with_reviewable_drafts, -> { where(id: SolutionDraft.in_state(:in_review).select(:solution_id)) }

  # @param [User] user
  # @return [SolutionEditorAssignment]
  def assign_editor!(user)
    solution_editor_assignments.where(user:).first_or_create!
  end

  # @see Solutions::CreateDraft
  monadic_matcher! def create_draft(...)
    call_operation("solutions.create_draft", self, ...)
  end
end
