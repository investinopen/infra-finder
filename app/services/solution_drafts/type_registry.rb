# frozen_string_literal: true

module SolutionDrafts
  # The type registry used by {SolutionDraft}s.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :draft_state, SolutionDrafts::Types::DraftState
    tc.add! :notification_targets, SolutionDrafts::Types::NotificationTargets
    tc.add! :workflow_action, SolutionDrafts::Types::WorkflowAction
  end
end
