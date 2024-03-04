# frozen_string_literal: true

module SolutionDrafts
  # Move a review from "IN_REVIEW" back to "PENDING", in order to have an editor
  # make further changes.
  #
  # @see SolutionDrafts::RequestRevision
  # @see SolutionDrafts::StateMachine
  class RevisionRequestor < BaseActor
    def perform
      yield monadic_transition(draft, :pending)

      super
    end
  end
end
