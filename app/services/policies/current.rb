# frozen_string_literal: true

module Policies
  # Per-request memoization for policy checks that would otherwise repeat for
  # every row of a collection.
  #
  # @see StandardTransitionPolicy#show?
  class Current < ActiveSupport::CurrentAttributes
    attribute :memo, default: -> { {} }

    class << self
      # @param [Array] key
      # @return [Object] the memoized value of the block
      def fetch(key)
        memo.fetch(key) { memo[key] = yield }
      end
    end
  end
end
