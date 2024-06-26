# frozen_string_literal: true

# @see SolutionUserContribution
# @see SolutionDraftUserContribution
class UserContribution < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  multiple!

  legacy_import_source_key :in_what_ways_names

  has_many :solution_draft_user_contributions, inverse_of: :user_contribution, dependent: :destroy
  has_many :solution_user_contributions, inverse_of: :user_contribution, dependent: :destroy

  has_many :solutions, through: :solution_user_contributions
  has_many :solution_drafts, through: :solution_draft_user_contributions
end
