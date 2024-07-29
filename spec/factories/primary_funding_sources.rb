# frozen_string_literal: true

FactoryBot.define do
  factory :primary_funding_source do
    sequence(:name) { "Primary Funding Source #{_1}" }
    sequence(:term) { "Primary Funding Source #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
