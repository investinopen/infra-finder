# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionsUnpublish
    class SolutionsUnpublish < VOGMutations::Implementation
      use_contract! :solutions_unpublish

      authorizes! :solutions, with: :unpublish_all?

      # @param [<Solution>] solutions
      # @return [void]
      def call(solutions:)
        ::Solution.where(id: solutions.map(&:id)).unpublish_all!

        attach! :solutions, solutions.each(&:reload)
      end
    end
  end
end
