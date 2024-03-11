# frozen_string_literal: true

module Comparisons
  # Remove a {Solution} from a {Comparison}.
  class Remove
    include Dry::Monads[:result, :do]

    # @param [Comparison] comparison
    # @param [Solution] solution
    # @return [Dry::Monads::Success(Comparison)]
    def call(comparison, solution)
      comparison.comparison_items.where(solution:).destroy_all

      Success comparison.reload
    end
  end
end
