# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      confirmed { true }
    end

    sequence(:email) { "test-#{_1.to_s.rjust(3, ?0)}@example.com" }
    name { "Test User" }
    password { "123456" }

    trait :accepted_terms do
      accept_terms_and_conditions { true }
    end

    trait :with_super_admin do
      super_admin { true }
    end

    trait :with_admin do
      admin { true }
    end

    after(:build) do |user, evaluator|
      user.skip_confirmation! if evaluator.confirmed
    end
  end
end
