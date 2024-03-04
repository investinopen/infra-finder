# frozen_string_literal: true

FactoryBot.define do
  factory :license do
    sequence(:name) { "License #{_1}" }
    description { "A description" }
    url { "https://example.org/license" }
  end
end
