# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionCreate
    class SolutionCreate < VOGMutations::Implementation
      use_contract! :solution_create
      use_contract! :mutate_solution

      authorizes! :solution, with: :create?

      attachment! :logo, image: true

      # A new solution may be incomplete, but its values must be valid. It gets its
      # initial revision.
      #
      # @param [Solution] solution
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(solution:, **attrs)
        assign_attributes!(solution, **attrs)

        persist_model! solution, attach_to: :solution

        solution.initialize_revision!(reason: "Created through the API")
      end

      # @return [void]
      before_prepare def initialize_solution!
        args[:solution] = Solution.new
      end
    end
  end
end
