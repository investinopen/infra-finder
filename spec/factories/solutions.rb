# frozen_string_literal: true

FactoryBot.define do
  factory :solution do
    association(:provider)
    sequence(:name) { "Solution #{_1}" }
    founded_on { Date.new(2020, 1, 1) }
    website { "https://example.org" }

    trait :barebones do
      founded_on { nil }
      contact { nil }
      website { nil }
    end

    trait :maintenance_active do
      maintenance_status { "active" }
    end

    trait :maintenance_inactive do
      maintenance_status { "inactive" }
    end

    trait :with_key_technologies do
      key_technology_list { "ruby, postgresql, rust" }
    end
  end
end
