# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionsPublish
    class SolutionsPublish < VOGMutations::Implementation
      use_contract! :solutions_publish

      authorizes! :solutions, with: :publish_all?

      # @param [<Solution>] solutions
      # @return [void]
      def call(solutions:)
        ::Solution.where(id: solutions.map(&:id)).publish_all!

        attach! :solutions, solutions.each(&:reload)
      end
    end
  end
end
