# frozen_string_literal: true

FactoryBot.define do
  factory :solution_intake do
    association(:provider)

    sequence(:name) { |n| "Solution From Intake #{n}" }
  end
end
