# frozen_string_literal: true

FactoryBot.define do
  factory :content_license do
    sequence(:name) { "Content License #{_1}" }
    sequence(:term) { "Content License #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
