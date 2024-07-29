# frozen_string_literal: true

FactoryBot.define do
  factory :preservation_standard do
    sequence(:name) { "Preservation Standard #{_1}" }
    sequence(:term) { "Preservation Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
