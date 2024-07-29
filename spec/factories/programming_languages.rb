# frozen_string_literal: true

FactoryBot.define do
  factory :programming_language do
    sequence(:name) { "Programming Language #{_1}" }
    sequence(:term) { "Programming Language #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
