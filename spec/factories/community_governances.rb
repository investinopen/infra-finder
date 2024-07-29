# frozen_string_literal: true

FactoryBot.define do
  factory :community_governance do
    sequence(:name) { "Community Governance #{_1}" }
    sequence(:term) { "Community Governance #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
