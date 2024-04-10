# frozen_string_literal: true

module Comparisons
  module Sharing
    class Accept
      include Dry::Monads[:result, :do]

      # @param [Comparison] comparison
      # @param [ComparisonShare] comparison_share
      # @return [Dry::Monads::Success(Comparison)]
      def call(comparison, comparison_share)
        comparison.search_filters = comparison_share.search_filters

        comparison.solutions = comparison_share.solutions

        comparison.save!

        Success comparison.reload
      end
    end
  end
end
