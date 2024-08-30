# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    subscribable { nil }
    kind { "" }
  end
end
