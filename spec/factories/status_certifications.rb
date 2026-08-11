# frozen_string_literal: true

FactoryBot.define do
  factory :status_certification do
    sequence(:name) { "Status Certification #{_1}" }
    sequence(:term) { "Status Certification #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
