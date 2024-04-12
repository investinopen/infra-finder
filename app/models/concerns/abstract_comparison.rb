# frozen_string_literal: true

# @see Comparison
# @see ComparisonShare
module AbstractComparison
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    before_validation :detect_item_state!, on: :update

    after_touch :recheck_item_state!
  end

  def sharable_search_filters
    # :nocov:
    call_operation("comparisons.sharing.prune_search_filters", search_filters.as_json)
    # :nocov:
  end

  def to_share_options
    {
      search_filters: search_filters.as_json,
      solution_ids:,
    }
  end

  # @!group Extended Item Predications

  # @param [Solution] solution
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
    item_count = solutions.count

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
end
