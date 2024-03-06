# frozen_string_literal: true

class ReadinessLevel < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!

  legacy_import_source_key :technology_readiness_level_id
end
