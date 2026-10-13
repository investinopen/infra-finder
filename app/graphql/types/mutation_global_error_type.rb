# frozen_string_literal: true

module Types
  # A global error for a mutation—not tied to a specific input field.
  #
  # @see VOGMutations::Error
  class MutationGlobalErrorType < Types::BaseObject
    description <<~TEXT
    An error that encapsulates the entire mutation input
    and is not tied to a specific input field.
    TEXT

    field :type, String, null: false

    field :message, String, null: false, description: "The actual message"
  end
end
