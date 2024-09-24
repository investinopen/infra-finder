# frozen_string_literal: true

# @see SolutionDraft
# @see SolutionDrafts::StateMachine
class SolutionDraftTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :solution_draft, inverse_of: :solution_draft_transitions

  scope :for_admin_history, -> { reorder(created_at: :asc, sort_key: :asc) }
end
