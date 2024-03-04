# frozen_string_literal: true

FactoryBot.define do
  factory :readiness_level do
    sequence(:name) { "Readiness Level #{_1}" }
  end
end
