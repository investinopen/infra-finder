# frozen_string_literal: true

FactoryBot.define do
  factory :solution_draft do
    association(:service)
  end
end
