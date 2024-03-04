# frozen_string_literal: true

module SolutionDrafts
  # @see SolutionDraft
  # @see SolutionDraftTransition
  class StateMachine
    include Statesman::Machine
    include StateMachineSelectOptions

    state :pending, initial: true
    state :in_review
    state :approved
    state :rejected

    transition from: :pending, to: :in_review
    transition from: :in_review, to: :pending
    transition from: :in_review, to: :approved
    transition from: :in_review, to: :rejected
  end
end
