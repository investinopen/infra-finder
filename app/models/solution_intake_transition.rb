# frozen_string_literal: true

# @see SolutionIntake
# @see SolutionIntakes::StateMachine
class SolutionIntakeTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :solution_intake_state

  belongs_to :solution_intake, inverse_of: :solution_intake_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :solution_intake
  transitions_association_name :solution_intake_transitions

  attribute :metadata, SolutionIntakes::TransitionMetadata.to_type

  delegate :note, :source, :via_admin?, :via_form?, :via_unspecified?, to: :metadata

  scope :for_admin_history, -> { reorder(created_at: :asc, sort_key: :asc) }
end
