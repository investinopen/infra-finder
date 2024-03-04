# frozen_string_literal: true

FactoryBot.define do
  factory :solution_category_draft_links do
    association(:solution_draft)
    association(:solution_category)
  end
end
