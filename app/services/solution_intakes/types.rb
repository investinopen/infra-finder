# frozen_string_literal: true

module SolutionIntakes
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    include Solutions::Types

    IntakeState = Coercible::Symbol.default(SolutionIntakes::StateMachine.initial_state.to_sym).enum(*SolutionIntakes::StateMachine.states.map(&:to_sym))
  end
end
