# frozen_string_literal: true

FactoryBot.define do
  factory :user_contribution do
    sequence(:name) { "User Contribution #{_1}" }
    sequence(:term) { "User Contribution #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
