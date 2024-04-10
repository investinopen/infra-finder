# frozen_string_literal: true

FactoryBot.define do
  factory :comparison_share do
    transient do
      solution_ids { [] }
      share_context { Comparisons::Sharing::Context.new(search_filters:, solution_ids:) }
    end

    fingerprint { share_context.fingerprint }

    search_filters do
      {
        "bylaws_available" => "true",
        "privacy_policy_available" => "false",
        # We generate a fake ID here so that the factory always generates a unique fingerprint
        "solution_categories_id_in" => [ SecureRandom.uuid, ]
      }
    end

    trait :shared do
      shared_at { Time.current }
      last_used_at { Time.current }
    end

    after(:create) do |comparison_share, evaluator|
      comparison_share.solutions = Solution.find(evaluator.solution_ids)
    end
  end
end
