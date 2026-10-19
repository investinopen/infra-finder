# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionDraftDestroy
    class SolutionDraftDestroy < VOGMutations::Implementation
      use_contract! :solution_draft_destroy

      authorizes! :solution_draft, with: :destroy?

      # @param [SolutionDraft] solution_draft
      # @return [void]
      def call(solution_draft:)
        destroy_model! solution_draft, auth: true
      end
    end
  end
end
