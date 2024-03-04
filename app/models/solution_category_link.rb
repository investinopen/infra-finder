# frozen_string_literal: true

# A connection between a {Solution} and a {SolutionCategory}.
class SolutionCategoryLink < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution, inverse_of: :solution_category_links
  belongs_to :solution_category, inverse_of: :solution_category_links
end
