# frozen_string_literal: true

FactoryBot.define do
  factory :security_standard do
    sequence(:name) { "Security Standard #{_1}" }
    sequence(:term) { "Security Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
