# frozen_string_literal: true

FactoryBot.define do
  factory :solution_draft_user_contribution do
    association(:solution_draft)
    association(:user_contribution)
  end
end
