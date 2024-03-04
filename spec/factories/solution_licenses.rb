# frozen_string_literal: true

FactoryBot.define do
  factory :solution_license do
    association(:solution)
    association(:license)
  end
end
