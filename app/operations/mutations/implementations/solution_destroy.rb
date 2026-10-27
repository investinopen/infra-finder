# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionDestroy
    class SolutionDestroy < VOGMutations::Implementation
      use_contract! :solution_destroy

      authorizes! :solution, with: :destroy?

      # @param [Solution] solution
      # @return [void]
      def call(solution:)
        destroy_model! solution, auth: true
      end
    end
  end
end
