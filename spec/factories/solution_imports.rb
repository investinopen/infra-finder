# frozen_string_literal: true

FactoryBot.define do
  factory :solution_import do
    skip_process { true }
    source { Rails.root.join("spec", "data", "solution-import-legacy-valid.csv").open("r+") }
    strategy { "legacy" }
  end
end
