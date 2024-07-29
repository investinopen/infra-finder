# frozen_string_literal: true

FactoryBot.define do
  factory :persistent_identifier_standard do
    sequence(:name) { "Persistent Identifier Standard #{_1}" }
    sequence(:term) { "Persistent Identifier Standard #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
