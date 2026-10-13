# frozen_string_literal: true

module Types
  # @api private
  # @note Testing use only.
  # @see Mutations::ErrorTest
  class ErrorTestTopLevelInputType < Types::HashInputObject
    description <<~TEXT
    An input object used in testing.
    TEXT

    argument :nested, [Types::ErrorTestNestedInputType, { null: false }], required: false do
      description "A list of nested input objects."
    end

    argument :name, String, required: true do
      description "The name of the test user."
    end
  end
end
