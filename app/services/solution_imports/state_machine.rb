# frozen_string_literal: true

module SolutionImports
  # State machine for a {SolutionImport}
  #
  # @see SolutionImportTransition
  class StateMachine
    include Statesman::Machine

    state :pending, initial: true
    state :invalid
    state :started
    state :success
    state :failure

    transition from: :pending, to: :invalid
    transition from: :pending, to: :started
    transition from: :started, to: :success
    transition from: :started, to: :failure

    after_transition(to: :started) do |solution_import, _|
      solution_import.touch(:started_at)
    end

    after_transition(to: :success) do |solution_import, _|
      solution_import.touch(:success_at)
    end

    after_transition(to: :failure) do |solution_import, _|
      solution_import.touch(:failure_at)
    end
  end
end
