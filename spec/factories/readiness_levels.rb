# frozen_string_literal: true

FactoryBot.define do
  factory :readiness_level do
    sequence(:name) { "Readiness Level #{_1}" }
    sequence(:term) { "Readiness Level #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
