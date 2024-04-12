# frozen_string_literal: true

# A connection between a {Solution} and a {Comparison}.
#
# @see Comparisons::Add
# @see Comparisons::Remove
class ComparisonItem < ApplicationRecord
  include TimestampScopes

  # The maximum number of items that can be added to a comparison.
  MAX_ITEMS = 4

  belongs_to :comparison, inverse_of: :comparison_items, counter_cache: true, touch: true
  belongs_to :solution, inverse_of: :comparison_items

  scope :for_comparison, -> { in_default_order.limit(MAX_ITEMS) }
  scope :in_default_order, -> { reorder(position: :desc) }

  # @note We actually want add_new_at: :bottom, but something isn't working.
  #   So we keep add_new_at: :top and just use position: :desc in the above
  #   scope to achieve the same effect.
  acts_as_list scope: :comparison_id, add_new_at: :top

  validate :enforce_item_count!

  validates :solution_id, uniqueness: { scope: :comparison_id }

  private

  # @return [void]
  def enforce_item_count!
    sibling_count = ComparisonItem.where(comparison:).where.not(id:).count

    return if sibling_count < MAX_ITEMS

    errors.add :base, :items_exceeded, count: MAX_ITEMS, strict: Comparisons::ItemsExceeded
  end
end
