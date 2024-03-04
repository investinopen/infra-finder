# frozen_string_literal: true

module SolutionDrafts
  # Move a review from "PENDING" to "IN_REVIEW", in order to allow an admin
  # to decide whether or not to `approve` or `reject` or `request_revision`.
  #
  # @see SolutionDrafts::ReviewRequestor
  class RequestReview < Support::SimpleServiceOperation
    service_klass SolutionDrafts::ReviewRequestor
  end
end
