# frozen_string_literal: true

FactoryBot.define do
  factory :domain_relevance do
    sequence(:name) { "Domain Relevance #{_1}" }
    sequence(:term) { "Domain Relevance #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
