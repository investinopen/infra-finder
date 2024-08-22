# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    sequence(:name) { "Integration #{_1}" }
    sequence(:term) { "Integration #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end