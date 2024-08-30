# frozen_string_literal: true

module SolutionDrafts
  # Move a review from "IN_REVIEW" back to "PENDING", in order to have an editor
  # make further changes.
  #
  # @see SolutionDrafts::RequestRevision
  # @see SolutionDrafts::StateMachine
  class RevisionRequestor < WorkflowActor
    transitions_to! :pending
  end
end
