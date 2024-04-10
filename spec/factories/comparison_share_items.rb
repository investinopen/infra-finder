# frozen_string_literal: true

FactoryBot.define do
  factory :comparison_share_item do
    association :comparison_share
    association :solution
  end
end
