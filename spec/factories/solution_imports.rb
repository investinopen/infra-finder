# frozen_string_literal: true

FactoryBot.define do
  factory :solution_import do
    transient do
      auto_approve { false }
    end

    options { { auto_approve:, } }

    skip_process { true }

    trait :eoi do
      source { Rails.root.join("spec", "data", "imports", "eoi-valid.csv").open("r+") }
      strategy { "eoi" }
    end

    trait :legacy do
      source { Rails.root.join("spec", "data", "solution-import-legacy-valid.csv").open("r+") }
      strategy { "legacy" }
    end

    trait :v2 do
      source { Rails.root.join("spec", "data", "imports", "v2-valid.csv").open("r+") }
      strategy { "v2" }
    end

    eoi
  end
end
