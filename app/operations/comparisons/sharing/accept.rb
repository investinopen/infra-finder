# frozen_string_literal: true

module Comparisons
  module Sharing
    class Accept
      include Dry::Monads[:result, :do]

      # @param [Comparison] comparison
      # @param [ComparisonShare] comparison_share
      # @return [Dry::Monads::Success(Comparison, Boolean)]
      def call(comparison, comparison_share)
        if comparison.fingerprint == comparison_share.fingerprint
          return Success([comparison, false])
        end

        comparison.search_filters = comparison_share.search_filters

        comparison.solutions = comparison_share.solutions

        comparison.save!

        Success [comparison.reload, true]
      end
    end
  end
end
