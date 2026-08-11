# frozen_string_literal: true

# @see SolutionIntake
# @see SolutionIntakes::StateMachine
class SolutionIntakeTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :solution_intake, inverse_of: :solution_intake_transitions

  belongs_to :user, inverse_of: :solution_intake_transitions, optional: true

  attribute :metadata, SolutionIntakes::TransitionMetadata.to_type

  delegate :note, :source, :via_admin?, :via_form?, :via_unspecified?, to: :metadata

  scope :for_admin_history, -> { reorder(created_at: :asc, sort_key: :asc) }
end
