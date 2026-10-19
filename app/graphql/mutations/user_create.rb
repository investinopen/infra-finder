# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::UserCreate
  class UserCreate < Mutations::MutateUser
    description <<~TEXT
    Create a single `User` record.
    TEXT

    argument :email, String, required: true do
      description "The user's email address."
    end

    argument :name, String, required: true do
      description "The user's display name."
    end

    argument :password, String, required: true do
      description "The user's password."
    end

    argument :password_confirmation, String, required: true do
      description "Must match `password`."
    end

    performs_operation! "mutations.implementations.user_create"
  end
end
