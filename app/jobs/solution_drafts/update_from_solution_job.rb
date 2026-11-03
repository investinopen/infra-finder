# frozen_string_literal: true

module SolutionDrafts
  # @see SolutionDrafts::UpdateFromSolution
  class UpdateFromSolutionJob < ApplicationJob
    queue_as :default

    # @param [SolutionDraft] draft
    # @return [void]
    def perform(draft)
      draft.update_from_solution!
    end
  end
end
