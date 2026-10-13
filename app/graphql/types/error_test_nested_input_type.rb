# frozen_string_literal: true

module Types
  # @api private
  # @note Testing use only.
  # @see Mutations::ErrorTest
  class ErrorTestNestedInputType < Types::HashInputObject
    description <<~TEXT
    A nested input object used in testing.
    TEXT

    argument :user_id, ID, loads: Types::UserType, required: true do
      description "The ID of the user."
    end

    argument :detail, String, required: true, transient: true do
      description "An optional string field."
    end
  end
end
