# frozen_string_literal: true

FactoryBot.define do
  factory :metrics_standard do
    sequence(:name) { "Metrics Standard #{_1}" }
    sequence(:term) { "Metrics Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
