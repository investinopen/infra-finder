# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:name) { "Role #{_1}" }
  end
end
