# frozen_string_literal: true

FactoryBot.define do
  factory :solution do
    transient do
      editors { [] }
    end

    association(:provider)
    sequence(:name) { "Solution #{_1}" }
    founded_on { Date.new(2020, 1, 1) }
    website { "https://example.org" }

    trait :barebones do
      founded_on { nil }
      contact { nil }
      website { nil }
    end

    # Writes the columns directly, so specs that only need a published solution
    # don't depend on what publishing validates.
    trait :published do
      after(:create) do |solution|
        solution.update_columns(publication: "published", published_at: Time.current)
      end
    end

    trait :maintenance_active do
      # maintenance_status { "active" }
    end

    trait :maintenance_inactive do
      # maintenance_status { "inactive" }
    end

    trait :with_key_technologies do
      # key_technology_list { "ruby, postgresql, rust" }
    end

    after(:create) do |solution, evaluator|
      evaluator.editors.each do |editor|
        solution.assign_editor!(editor)
      end
    end
  end
end
