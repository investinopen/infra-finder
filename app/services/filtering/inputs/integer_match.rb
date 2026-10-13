# frozen_string_literal: true

module Filtering
  module Inputs
    # A comparator match input for integer values.
    #
    # @see Filtering::HasArguments#integer_match
    class IntegerMatch < ComparatorMatch.of(:integer)
    end
  end
end
