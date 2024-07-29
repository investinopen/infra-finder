# frozen_string_literal: true

FactoryBot.define do
  factory :nonprofit_status do
    sequence(:name) { "Nonprofit Status #{_1}" }
    sequence(:term) { "Nonprofit Status #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
