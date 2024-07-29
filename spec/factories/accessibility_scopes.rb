# frozen_string_literal: true

FactoryBot.define do
  factory :accessibility_scope do
    sequence(:name) { "Accessibility Scope #{_1}" }
    sequence(:term) { "Accessibility Scope #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
