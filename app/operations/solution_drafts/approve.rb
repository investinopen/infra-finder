# frozen_string_literal: true

module SolutionDrafts
  # Approve a {SolutionDraft} and apply its changes to its parent {Solution}.
  #
  # @see SolutionDrafts::Approver
  class Approve < Support::SimpleServiceOperation
    service_klass SolutionDrafts::Approver
  end
end
