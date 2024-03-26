# frozen_string_literal: true

module Comparisons
  # An error raised when the {ComparisonItem::MAX_ITEMS} is exceeded.
  #
  # @see Comparisons::Add
  class ItemsExceeded < ActiveModel::StrictValidationFailed; end
end
