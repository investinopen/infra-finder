# frozen_string_literal: true

module SolutionDrafts
  # Check a {SolutionDraft} and update its changes against its parent {Solution}.
  #
  # @see SolutionDrafts::Checker
  class Check < Support::SimpleServiceOperation
    service_klass SolutionDrafts::Checker
  end
end
