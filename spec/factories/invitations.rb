# frozen_string_literal: true

FactoryBot.define do
  factory :invitation do
    association :provider

    email { Faker::Internet.unique.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    memo { Faker::Lorem.paragraph }
  end
end
