# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionDraftUpdate
    class SolutionDraftUpdate < VOGMutations::Implementation
      use_contract! :solution_draft_update
      use_contract! :mutate_solution_draft

      authorizes! :solution_draft, with: :update?

      attachment! :logo, image: true

      # A draft may be incomplete, but its values must be valid.
      #
      # @param [SolutionDraft] solution_draft
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(solution_draft:, **attrs)
        assign_attributes!(solution_draft, **attrs)

        persist_model! solution_draft, attach_to: :solution_draft
      end
    end
  end
end
