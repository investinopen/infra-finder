# frozen_string_literal: true

module SolutionDrafts
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    include Solutions::Types

    DraftState = Coercible::Symbol.default(SolutionDrafts::StateMachine.initial_state.to_sym).enum(*SolutionDrafts::StateMachine.states.map(&:to_sym))

    NotificationTargets = Coercible::Symbol.enum(:admins, :editors)

    WorkflowAction = Coercible::Symbol.enum(:request_revision, :request_review, :approve, :reject)
  end
end
