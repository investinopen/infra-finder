# frozen_string_literal: true

FactoryBot.define do
  factory :hosting_strategy do
    sequence(:name) { "HS #{_1}" }
    visibility { "visible" }
  end
end
