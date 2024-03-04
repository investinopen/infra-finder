# frozen_string_literal: true

# A link between a {Solution} and a {License}.
class SolutionLicense < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution, inverse_of: :solution_licenses
  belongs_to :license, inverse_of: :solution_licenses
end
