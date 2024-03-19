# frozen_string_literal: true

FactoryBot.define do
  factory :comparison_item do
    association(:comparison)
    association(:solution)
  end
end
