# frozen_string_literal: true

FactoryBot.define do
  factory :hosting_strategy do
    sequence(:name) { "Hosting Strategy #{_1}" }
    sequence(:term) { "Hosting Strategy #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
