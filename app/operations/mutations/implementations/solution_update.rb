# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionUpdate
    class SolutionUpdate < VOGMutations::Implementation
      use_contract! :solution_update
      use_contract! :mutate_solution

      authorizes! :solution, with: :update?

      attachment! :logo, image: true

      # A solution may be saved incomplete, but its values must be valid, and publishing
      # it requires completeness. Each update records a direct revision.
      #
      # @param [Solution] solution
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(solution:, **attrs)
        assign_attributes!(solution, **attrs)

        persist_model! solution, attach_to: :solution

        solution.create_revision!(kind: :direct, reason: "Updated directly through the API")
      end
    end
  end
end
