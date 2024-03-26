# frozen_string_literal: true

module Comparisons
  # Add a {Solution} to a {Comparison}.
  class Add
    include Dry::Monads[:result, :do]

    # @param [Comparison] comparison
    # @param [Solution] solution
    # @return [Dry::Monads::Success(Comparison)]
    def call(comparison, solution)
      item = comparison.comparison_items.where(solution:).first_or_create!

      item.move_to_top

      Success comparison.reload
    rescue Comparisons::ItemsExceeded => e
      Failure[:items_exceeded, e.message]
    end
  end
end
