# frozen_string_literal: true

# A session-based model for tracking comparisons between various {Solution}s.
class Comparison < ApplicationRecord
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

  scope :prunable, -> { where(arel_prunable) }

  before_validation :detect_item_state!, on: :update

  after_touch :recheck_item_state!

  validates :session_id, presence: true, uniqueness: true

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
    filters_with_existing_sort = new_search_filters.reverse_merge(search_filters.slice(?s))

    update_column(:search_filters, filters_with_existing_sort)
  end

  # @param [String, nil] raw_sort
  # @return [void]
  def apply_sorts!(raw_sort)
    sort = raw_sort.presence_in(ACCEPTABLE_SORTS) || DEFAULT_SORT

    new_search_filters = search_filters.merge("s" => sort)

    update_column(:search_filters, new_search_filters)
  end

  # @return [void]
  def clear_filters!
    update_columns(search_filters: {})
  end

  # @!endgroup

  # @!group Extended Item Predications

  # @param [Solution]
  def comparing?(solution)
    solution.in? solutions.to_a
  end

  def items_addable?
    !items_maxed_out?
  end

  def items_comparable?
    items_many? || items_maxed_out?
  end

  def items_incomparable?
    !items_comparable?
  end

  # @!endgroup

  private

  # @return ["empty", "single", "many", "maxed_out"]
  def detect_item_state
    item_count = ComparisonItem.where(comparison_id: id).count

    case item_count
    when 0 then "empty"
    when ComparisonItem::MAX_ITEMS.. then "maxed_out"
    when 2...ComparisonItem::MAX_ITEMS then "many"
    else
      "single"
    end
  end

  # @return [void]
  def detect_item_state!
    self.item_state = detect_item_state
  end

  # @return [void]
  def recheck_item_state!
    detect_item_state!

    update_column(:item_state, item_state) if item_state_changed?
  end

  class << self
    def arel_prunable
      last_seen_at = arel_table[:last_seen_at]

      never_seen = last_seen_at.eq(nil)

      too_old = last_seen_at.lt(PRUNABLE_AGE.ago)

      never_seen.or(too_old)
    end
  end
end
