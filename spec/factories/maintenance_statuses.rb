# frozen_string_literal: true

FactoryBot.define do
  factory :maintenance_status do
    sequence(:name) { "Maintenance Status #{_1}" }
    sequence(:term) { "Maintenance Status #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
