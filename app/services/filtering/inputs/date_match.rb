# frozen_string_literal: true

module Filtering
  module Inputs
    # A comparator match input for date values.
    #
    # @see Filtering::HasArguments#date_match
    class DateMatch < ComparatorMatch.of(:date)
    end
  end
end
