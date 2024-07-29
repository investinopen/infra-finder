# frozen_string_literal: true

FactoryBot.define do
  factory :solution_category do
    sequence(:name) { "Solution Category #{_1}" }
    sequence(:term) { "Solution Category #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
