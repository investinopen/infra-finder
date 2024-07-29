# frozen_string_literal: true

FactoryBot.define do
  factory :board_structure do
    sequence(:name) { "Board Structure #{_1}" }
    sequence(:term) { "Board Structure #{_1}" }

    visibility { "visible" }

    trait :visible do
      visibility { "visible" }
    end

    trait :hidden do
      visibility { "hidden" }
    end
  end
end
