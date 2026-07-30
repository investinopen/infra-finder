# frozen_string_literal: true

FactoryBot.define do
  factory :access_condition do
    sequence(:name) { "Access Condition #{_1}" }
    sequence(:term) { "Access Condition #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
