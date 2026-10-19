# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionDraftRequestReview
    class SolutionDraftRequestReview < VOGMutations::Implementation
      use_contract! :solution_draft_request_review

      authorizes! :solution_draft, with: :request_review?

      # @param [SolutionDraft] solution_draft
      # @param [String, nil] memo
      # @return [void]
      def call(solution_draft:, memo: nil)
        solution_draft.request_review(memo:, user: current_user) do |m|
          m.success do
            attach! :solution_draft, solution_draft
          end

          m.failure do
            something_went_wrong!
          end
        end
      end
    end
  end
end
