# frozen_string_literal: true

FactoryBot.define do
  factory :solution_editor_assignment do
    association :solution
    association :user
  end
end
