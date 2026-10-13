# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ErrorTest
  class ErrorTest < Mutations::BaseMutation
    description <<~TEXT
    This mutation is only used in testing and should not have any
    UI / production uses.
    TEXT

    field :ok, Boolean, null: true do
      description "Indicates whether the operation was successful."
    end

    field :date, GraphQL::Types::ISO8601Date, null: true do
      description "A test date value returned by the mutation."
    end

    field :time, GraphQL::Types::ISO8601DateTime, null: true do
      description "A test time value returned by the mutation."
    end

    field :test, Float, null: true do
      description "A test float value returned by the mutation."
    end

    field :int, Integer, null: true do
      description "A test integer value returned by the mutation."
    end

    argument :inputs, [Types::ErrorTestTopLevelInputType, { null: false }], required: true do
      description "A list of test input objects."
    end

    performs_operation! "mutations.implementations.error_test"
  end
end
