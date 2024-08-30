# frozen_string_literal: true

module SolutionDrafts
  # Move a review from "PENDING" to "IN_REVIEW", in order to allow an admin
  # to decide whether or not to `approve` or `reject` or `request_revision`.
  #
  # @see SolutionDrafts::RequestReview
  # @see SolutionDrafts::StateMachine
  class ReviewRequestor < WorkflowActor
    transitions_to! :in_review
  end
end
