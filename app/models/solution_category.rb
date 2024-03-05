# frozen_string_literal: true

# A category that describes what a {Solution} (or pending {SolutionDraft}) can be used for.
class SolutionCategory < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  multiple!

  has_many :solution_category_draft_links, inverse_of: :solution_category, dependent: :destroy
  has_many :solution_category_links, inverse_of: :solution_category, dependent: :destroy

  has_many :solutions, through: :solution_category_links
end
