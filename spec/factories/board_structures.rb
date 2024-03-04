# frozen_string_literal: true

FactoryBot.define do
  factory :board_structure do
    sequence(:name) { "Board Structure #{_1}" }
  end
end
