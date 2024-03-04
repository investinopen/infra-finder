# frozen_string_literal: true

FactoryBot.define do
  factory :community_governance do
    sequence(:name) { "CG #{_1}" }
  end
end
