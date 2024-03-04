# frozen_string_literal: true

# A connection between a {SolutionDraft} and a {License}.
class SolutionDraftLicense < ApplicationRecord
  include SolutionOptionLink

  belongs_to :solution_draft, inverse_of: :solution_draft_licenses
  belongs_to :license, inverse_of: :solution_draft_licenses
end
