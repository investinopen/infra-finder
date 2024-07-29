# frozen_string_literal: true

FactoryBot.define do
  factory :metadata_standard do
    sequence(:name) { "Metadata Standard #{_1}" }
    sequence(:term) { "Metadata Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
