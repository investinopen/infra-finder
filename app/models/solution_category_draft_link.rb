# frozen_string_literal: true

# A connection between a {SolutionDraft} and a {SolutionCategory}.
class SolutionCategoryDraftLink < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution_draft, inverse_of: :solution_category_draft_links
  belongs_to :solution_category, inverse_of: :solution_category_draft_links
end
