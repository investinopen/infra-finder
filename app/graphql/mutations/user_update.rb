# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserUpdate
  class UserUpdate < Mutations::MutateUser
    description <<~TEXT
    Update a single `User` record.
    TEXT

    argument :user_id, ID, loads: Types::UserType, required: true do
      description <<~TEXT
      The user to update.
      TEXT
    end

    performs_operation! "mutations.implementations.user_update"
  end
end
