# frozen_string_literal: true

FactoryBot.define do
  factory :comparison do
    session_id { SecureRandom.hex(24) }

    trait :prunable do
      last_seen_at { (Comparison::PRUNABLE_AGE + 1.day).ago }
    end
  end
end
