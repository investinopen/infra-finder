# frozen_string_literal: true

FactoryBot.define do
  factory :solution_category do
    sequence(:name) { "Solution Category #{_1}" }
  end
end
