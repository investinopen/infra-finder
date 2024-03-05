# frozen_string_literal: true

FactoryBot.define do
  factory :solution do
    association(:organization)
    sequence(:name) { "Solution #{_1}" }
    founded_on { Date.new(2020, 1, 1) }
    website { "https://example.org" }
  end
end
