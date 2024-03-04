# frozen_string_literal: true

FactoryBot.define do
  factory :user_contribution do
    sequence(:name) { "User Contribution #{_1}" }
  end
end
