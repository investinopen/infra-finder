# frozen_string_literal: true

FactoryBot.define do
  factory :maintenance_status do
    sequence(:name) { "Maintenance Status #{_1}" }
    visibility { "visible" }
  end
end
