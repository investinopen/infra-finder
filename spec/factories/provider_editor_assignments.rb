# frozen_string_literal: true

FactoryBot.define do
  factory :provider_editor_assignment do
    association :provider
    association :user
  end
end
