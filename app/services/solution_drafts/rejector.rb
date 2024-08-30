# frozen_string_literal: true

module SolutionDrafts
  # Reject a {SolutionDraft} and file it away to eventually be discarded.
  #
  # @see SolutionDrafts::Reject
  # @see SolutionDrafts::StateMachine
  class Rejector < WorkflowActor
    transitions_to! :rejected
  end
end
