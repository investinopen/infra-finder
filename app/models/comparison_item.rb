# frozen_string_literal: true

# A connection between a {Solution} and a {Comparison}.
#
# @see Comparisons::Add
# @see Comparisons::Remove
class ComparisonItem < ApplicationRecord
  include TimestampScopes

  belongs_to :comparison, inverse_of: :comparison_items
  belongs_to :solution, inverse_of: :comparison_items

  scope :in_default_order, -> { reorder(position: :asc) }

  acts_as_list scope: :comparison_id, add_new_at: :top

  validates :solution_id, uniqueness: { scope: :comparison_id }
end
