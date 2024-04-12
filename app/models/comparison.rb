# frozen_string_literal: true

# A session-based model for tracking comparisons between various {Solution}s.
class Comparison < ApplicationRecord
  include AbstractComparison
  include TimestampScopes

  ACCEPTABLE_SORTS = [
    "updated_at desc",
    "name asc",
    "name desc",
  ].freeze

  DEFAULT_SORT = "updated_at desc"

  PRUNABLE_AGE = 7.days

  pg_enum! :item_state, as: :comparison_item_state, allow_blank: false, default: :empty, prefix: :items

  has_many :comparison_items, -> { for_comparison }, inverse_of: :comparison, dependent: :destroy

  has_many :solutions, through: :comparison_items

  belongs_to :comparison_share, inverse_of: :comparisons, foreign_key: :fingerprint, primary_key: :fingerprint, optional: true

  scope :prunable, -> { where(arel_prunable) }

  attribute :search_filters, Comparisons::SearchFilters.to_type, default: -> { {} }

  after_update :regenerate_comparison_share!

  after_touch :regenerate_comparison_share!

  validates :session_id, presence: true, uniqueness: true
  validates :search_filters, store_model: true

  # @see Comparisons::Add
  # @return [Dry::Monads::Result]
  monadic_matcher! def add(solution)
    call_operation("comparisons.add", self, solution)
  end

  # @see Comparisons::Remove
  # @return [Dry::Monads::Result]
  monadic_matcher! def remove(solution)
    call_operation("comparisons.remove", self, solution)
  end

  # @!group Filtering

  # @param [Hash] new_search_filters
  # @return [void]
  def apply_filters!(new_search_filters = {})
    self.search_filters = new_search_filters.reverse_merge(search_filters.slice(?s))

    save!
  end

  # @param [String, nil] raw_sort
  # @return [void]
  def apply_sorts!(raw_sort)
    search_filters.apply_sorts!(raw_sort)

    search_filters_will_change!

    save!
  end

  # @return [void]
  def clear_filters!
    self.search_filters = {}

    save!
  end

  # @!endgroup

  # @!group Sharing

  # @param [ComparisonShare] comparison_share
  # @return [Dry::Monads::Success(Comparison)]
  monadic_matcher! def accept_shared(comparison_share)
    call_operation("comparisons.sharing.accept", self, comparison_share)
  end

  # @return [Dry::Monads::Success(Comparison)]
  monadic_operation! def regenerate_comparison_share
    call_operation("comparisons.sharing.regenerate", self)
  end

  def sharable?
    fingerprint? && comparison_share.present?
  end

  # @!endgroup

  class << self
    def arel_prunable
      last_seen_at = arel_table[:last_seen_at]

      never_seen = last_seen_at.eq(nil)

      too_old = last_seen_at.lt(PRUNABLE_AGE.ago)

      never_seen.or(too_old)
    end
  end
end
