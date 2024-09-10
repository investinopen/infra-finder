# frozen_string_literal: true

# The primary content model for this application.
class Solution < ApplicationRecord
  include SolutionInterface
  include SluggedByName
  include TimestampScopes

  resourcify

  pg_enum! :publication, as: :publication, allow_blank: false, default: :unpublished

  belongs_to :provider, inverse_of: :solutions, counter_cache: true, touch: true

  has_many :provider_editor_assignments, through: :provider

  has_many :comparison_items, inverse_of: :solution, dependent: :destroy
  has_many :comparison_share_items, inverse_of: :solution, dependent: :destroy
  has_many :solution_drafts, -> { in_recent_order }, inverse_of: :solution, dependent: :destroy
  has_many :solution_editor_assignments, inverse_of: :solution, dependent: :destroy

  expose_ransackable_associations! :provider, :solution_drafts
  expose_ransackable_attributes! :provider_id, :publication
  expose_ransackable_scopes! :with_pending_drafts, :with_reviewable_drafts, :published, :unpublished

  delegate :name, to: :provider, prefix: true
  delegate :assign_editor!, to: :provider

  scope :with_editor_access_for, ->(user) { joins(:provider).merge(Provider.with_editor_access_for(user)) }
  scope :with_pending_drafts, -> { where(id: SolutionDraft.in_state(:pending).select(:solution_id)) }
  scope :with_reviewable_drafts, -> { where(id: SolutionDraft.in_state(:in_review).select(:solution_id)) }

  before_validation :maybe_touch_published_at!, if: :publication_changed?

  after_save :purge_comparisons!, if: :unpublished?

  # @see Solutions::CreateDraft
  monadic_matcher! def create_draft(...)
    call_operation("solutions.create_draft", self, ...)
  end

  private

  # @return [void]
  def maybe_touch_published_at!
    self.published_at = published? ? Time.current : nil
  end

  # @return [void]
  def purge_comparisons!
    comparison_items.destroy_all
    comparison_share_items.destroy_all
  end

  class << self
    # @return [<String>]
    def active_country_codes
      unscoped.distinct.where.not(country_code: nil).pluck(:country_code)
    end

    # @param [String] name
    # @return [String, nil]
    def identifier_by_name(name)
      where(name:).pick(:identifier)
    end

    # @param [User, nil] _user
    # @return [ActiveRecord::Relation<Solution>]
    def publicly_accessible_for(_user)
      published
    end

    # @param [<String>] ids
    # @return [Integer] count actually changed to published
    def publish_all!
      count = 0

      unpublished.find_each do |solution|
        solution.published!

        count += 1
      end

      return count
    end

    # @param [<String>] ids
    # @return [Integer] count actually changed to unpublished
    def unpublish_all!
      count = 0

      published.find_each do |solution|
        solution.unpublished!

        count += 1
      end

      return count
    end
  end
end
