# frozen_string_literal: true

# @see SolutionLicense
# @see SolutionDraftLicense
class License < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  multiple!

  legacy_import_source_key :license_type_names

  has_many :solution_draft_licenses, inverse_of: :license, dependent: :destroy
  has_many :solution_licenses, inverse_of: :license, dependent: :destroy

  has_many :solutions, through: :solution_licenses
  has_many :solution_drafts, through: :solution_draft_licenses
end
