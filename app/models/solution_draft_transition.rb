# frozen_string_literal: true

# @see SolutionDraft
# @see SolutionDrafts::StateMachine
class SolutionDraftTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :solution_draft, inverse_of: :solution_draft_transitions
end
