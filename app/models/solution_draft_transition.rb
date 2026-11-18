# frozen_string_literal: true

# @see SolutionDraft
# @see SolutionDrafts::StateMachine
class SolutionDraftTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :solution_draft_state

  belongs_to :solution_draft, inverse_of: :solution_draft_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :solution_draft
  transitions_association_name :solution_draft_transitions

  scope :for_admin_history, -> { reorder(created_at: :asc, sort_key: :asc) }
end
