# frozen_string_literal: true

module Types
  # An enum that determines the direction that page-number based pagination should flow.
  class PageDirectionType < Types::BaseEnum
    description "Determines the direction that page-number based pagination should flow"

    value "FORWARDS", value: :forwards
    value "BACKWARDS", value: :backwards
  end
end
