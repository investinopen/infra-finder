# frozen_string_literal: true

module Filtering
  module Inputs
    # A comparator match input for time values.
    #
    # @see Filtering::HasArguments#time_match
    class TimeMatch < ComparatorMatch.of(:time)
    end
  end
end
