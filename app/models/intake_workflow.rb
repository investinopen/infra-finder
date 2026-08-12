# frozen_string_literal: true

class IntakeWorkflow < Support::FrozenRecordHelpers::AbstractRecord
  extend DefinesMonadicOperation

  schema!(types: SolutionIntakes::TypeRegistry) do
    required(:action).filled(:workflow_action)
    required(:to_state).filled(:intake_state)
    required(:legend).filled(:string)
    required(:targets).filled(:notification_targets)
  end

  self.primary_key = :action

  add_index :action, unique: true
  add_index :to_state, unique: true

  # @return [Symbol]
  def label = :"intake_#{action}"

  # @param [ApplicationRecord] resource
  # @return [ActiveRecord::Relation<User>]
  def recipients_for(resource, initiator: nil)
    # :nocov:
    return User.none if initiator.blank?
    # :nocov:

    with_notifs = User.subscribed_to_solution_notifications.where.not(id: initiator.id)

    case targets
    in :admins
      with_notifs.any_admins
    in :editors
      with_notifs.editor_kind.with_access_to(resource)
    else
      # :nocov:
      with_notifs.none
      # :nocov:
    end
  end
end
