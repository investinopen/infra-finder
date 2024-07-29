# frozen_string_literal: true

FactoryBot.define do
  factory :reporting_level do
    sequence(:name) { "Reporting Level #{_1}" }
    sequence(:term) { "Reporting Level #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
