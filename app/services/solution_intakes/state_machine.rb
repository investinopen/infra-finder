# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntake
  # @see SolutionIntakeTransition
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

    after_transition do |solution_intake, transition|
      solution_intake.update_column :state, transition.to_state
    end
  end
end
