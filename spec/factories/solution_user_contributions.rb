# frozen_string_literal: true

FactoryBot.define do
  factory :solution_user_contribution do
    association(:solution)
    association(:user_contribution)
  end
end
