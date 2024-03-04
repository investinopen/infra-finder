# frozen_string_literal: true

FactoryBot.define do
  factory :solution_category_link do
    association(:solution)
    association(:solution_category)
  end
end
