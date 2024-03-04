# frozen_string_literal: true

FactoryBot.define do
  factory :business_form do
    sequence(:name) { "Business Form #{_1}" }
  end
end
