# frozen_string_literal: true

FactoryBot.define do
  factory :session_record do
    transient do
      age { 0.days }
      created_age { age }
      updated_age { age }
    end

    session_id { SecureRandom.hex }

    data { {} }

    created_at { created_age.ago }
    updated_at { updated_age.ago }

    trait :expired do
      age { (SessionConfig.ttl + 1).days }
    end
  end
end
