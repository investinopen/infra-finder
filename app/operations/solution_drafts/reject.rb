# frozen_string_literal: true

module SolutionDrafts
  # Reject a {SolutionDraft} and file it away to eventually be discarded.
  #
  # @see SolutionDrafts::Rejector
  class Reject < Support::SimpleServiceOperation
    service_klass SolutionDrafts::Rejector
  end
end
