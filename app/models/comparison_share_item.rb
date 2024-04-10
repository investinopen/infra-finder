# frozen_string_literal: true

# A connection between a {Solution} and a {ComparisonShare}.
class ComparisonShareItem < ApplicationRecord
  include TimestampScopes

  belongs_to :comparison_share, inverse_of: :comparison_share_items, counter_cache: true, touch: true
  belongs_to :solution, inverse_of: :comparison_items

  scope :for_comparison, -> { in_default_order.limit(ComparisonItem::MAX_ITEMS) }
  scope :in_default_order, -> { reorder(position: :asc) }

  acts_as_list scope: :comparison_share_id, add_new_at: :bottom
end
