# frozen_string_literal: true

FactoryBot.define do
  factory :revenue_source do
    sequence(:name) { "Revenue Source #{_1}" }
    sequence(:term) { "Revenue Source #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
