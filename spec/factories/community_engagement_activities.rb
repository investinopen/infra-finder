# frozen_string_literal: true

FactoryBot.define do
  factory :community_engagement_activity do
    sequence(:name) { "Community Engagement Activity #{_1}" }
    sequence(:term) { "Community Engagement Activity #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
