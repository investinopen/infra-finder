# frozen_string_literal: true

FactoryBot.define do
  factory :business_form do
    sequence(:name) { "Business Form #{_1}" }
    sequence(:term) { "Business Form #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
