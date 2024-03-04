# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.unique.name }

    trait :with_url do
      url { Faker::Internet.url }
    end
  end
end
