# frozen_string_literal: true

# A link between a {SolutionDraft} and a {UserContribution}.
class SolutionDraftUserContribution < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution_draft, inverse_of: :solution_draft_user_contributions
  belongs_to :user_contribution, inverse_of: :solution_draft_user_contributions
end
