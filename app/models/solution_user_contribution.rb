# frozen_string_literal: true

# A link between a {Solution} and a {UserContribution}.
class SolutionUserContribution < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution, inverse_of: :solution_user_contributions
  belongs_to :user_contribution, inverse_of: :solution_user_contributions
end
