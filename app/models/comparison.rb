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

  has_many :comparison_items, -> { in_default_order }, inverse_of: :comparison, dependent: :destroy

  has_many :solutions, through: :comparison_items

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
end
