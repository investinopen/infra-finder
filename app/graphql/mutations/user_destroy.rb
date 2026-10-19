# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserDestroy
  class UserDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `User` record.
    TEXT

    argument :user_id, ID, loads: Types::UserType, required: true do
      description <<~TEXT
      The user to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.user_destroy", destroy: true
  end
end
