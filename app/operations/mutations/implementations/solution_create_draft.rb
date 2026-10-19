# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionCreateDraft
    class SolutionCreateDraft < VOGMutations::Implementation
      use_contract! :solution_create_draft

      authorizes! :solution, with: :create_draft?

      # @param [Solution] solution
      # @return [void]
      def call(solution:)
        solution.create_draft(user: current_user) do |m|
          m.success do |draft|
            attach! :solution_draft, draft
          end

          m.failure(:pending_draft_exists) do
            add_global_error! I18n.t("admin.solutions.create_draft.pending_draft_exists"), type: "pending_draft_exists"
          end

          m.failure do
            something_went_wrong!
          end
        end
      end
    end
  end
end
