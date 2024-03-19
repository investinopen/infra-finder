# frozen_string_literal: true

FactoryBot.define do
  factory :comparison do
    session_id { SecureRandom.hex(24) }
  end
end
