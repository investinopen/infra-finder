# frozen_string_literal: true

module Filtering
  module Inputs
    # A comparator match input for float values.
    #
    # @see Filtering::HasArguments#float_match
    class FloatMatch < ComparatorMatch.of(:float)
    end
  end
end
