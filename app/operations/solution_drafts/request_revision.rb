# frozen_string_literal: true

module SolutionDrafts
  # Move a review from "IN_REVIEW" back to "PENDING", in order to have an editor
  # make further changes.
  #
  # @see SolutionDrafts::RevisionRequestor
  class RequestRevision < Support::SimpleServiceOperation
    service_klass SolutionDrafts::RevisionRequestor
  end
end
