# frozen_string_literal: true

FactoryBot.define do
  factory :values_framework do
    sequence(:name) { "Values Framework #{_1}" }
    sequence(:term) { "Values Framework #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
