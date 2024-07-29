# frozen_string_literal: true

FactoryBot.define do
  factory :license do
    sequence(:name) { "License #{_1}" }
    sequence(:term) { "License #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
