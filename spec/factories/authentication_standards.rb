# frozen_string_literal: true

FactoryBot.define do
  factory :authentication_standard do
    sequence(:name) { "Authentication Standard #{_1}" }
    sequence(:term) { "Authentication Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
