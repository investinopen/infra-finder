# frozen_string_literal: true

module SolutionDrafts
  # Reject a {SolutionDraft} and file it away to eventually be discarded.
  #
  # @see SolutionDrafts::Reject
  # @see SolutionDrafts::StateMachine
  class Rejector < BaseActor
    def perform
      yield monadic_transition(draft, :rejected)

      super
    end
  end
end
