# frozen_string_literal: true

FactoryBot.define do
  factory :solution_draft_license do
    association(:solution_draft)
    association(:license)
  end
end
