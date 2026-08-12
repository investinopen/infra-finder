# frozen_string_literal: true

module SolutionIntakes
  # The type registry used by {SolutionIntake}s.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :intake_state, SolutionIntakes::Types::IntakeState
    tc.add! :notification_targets, SolutionIntakes::Types::NotificationTargets
    tc.add! :workflow_action, SolutionIntakes::Types::WorkflowAction
  end
end
