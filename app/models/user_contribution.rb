# frozen_string_literal: true

# @see SolutionUserContribution
# @see SolutionDraftUserContribution
class UserContribution < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  multiple!

  has_many :solution_draft_user_contributions, inverse_of: :user_contribution, dependent: :destroy
  has_many :solution_user_contributions, inverse_of: :user_contribution, dependent: :destroy

  has_many :solutions, through: :solution_user_contributions
end
