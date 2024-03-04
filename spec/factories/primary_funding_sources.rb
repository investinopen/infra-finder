# frozen_string_literal: true

FactoryBot.define do
  factory :primary_funding_source do
    sequence(:name) { "Primary Funding Source #{_1}" }
  end
end
