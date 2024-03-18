# frozen_string_literal: true

# The primary content model for this application.
class Solution < ApplicationRecord
  include SolutionInterface
  include SluggedByName
  include TimestampScopes

  resourcify

  belongs_to :organization, inverse_of: :solutions

  has_many :comparison_items, inverse_of: :solution, dependent: :destroy
  has_many :solution_drafts, -> { in_recent_order }, inverse_of: :solution, dependent: :destroy
  has_many :solution_editor_assignments, inverse_of: :solution, dependent: :destroy

  define_common_attributes!
  expose_ransackable_associations! :solution_drafts
  expose_ransackable_attributes! :organization_id
  expose_ransackable_scopes! :with_pending_drafts, :with_reviewable_drafts

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
