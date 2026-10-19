# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionDraftUpdate
    class SolutionDraftUpdate < VOGMutations::Implementation
      use_contract! :solution_draft_update
      use_contract! :mutate_solution_draft

      authorizes! :solution_draft, with: :update?

      attachment! :logo, image: true

      # As in the admin section, a draft must satisfy the editor validations.
      #
      # @param [SolutionDraft] solution_draft
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(solution_draft:, **attrs)
        assign_attributes!(solution_draft, **attrs)

        solution_draft.apply_editor_validations = true

        persist_model! solution_draft, attach_to: :solution_draft
      end
    end
  end
end
