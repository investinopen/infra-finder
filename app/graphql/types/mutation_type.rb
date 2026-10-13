# frozen_string_literal: true

module Types
  # The base type for defining mutations.
  class MutationType < Types::BaseObject
    description <<~TEXT
    The entry point for making changes to the data within the API.
    TEXT

    field :error_test, mutation: Mutations::ErrorTest
  end
end
