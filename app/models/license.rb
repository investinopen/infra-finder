# frozen_string_literal: true

# @see SolutionLicense
# @see SolutionDraftLicense
class License < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  multiple!

  has_many :solution_draft_licenses, inverse_of: :license, dependent: :destroy
  has_many :solution_licenses, inverse_of: :license, dependent: :destroy

  has_many :solutions, through: :service_licenses
end
