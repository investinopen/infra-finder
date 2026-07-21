# frozen_string_literal: true

# @see SolutionIntake
# @see SolutionIntakes::StateMachine
class SolutionIntakeTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :solution_intake, inverse_of: :solution_intake_transitions

  scope :for_admin_history, -> { reorder(created_at: :asc, sort_key: :asc) }
end
