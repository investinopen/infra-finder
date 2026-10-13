# frozen_string_literal: true

module Types
  # A user of the admin interface.
  class UserType < Types::AbstractModel
    description <<~TEXT
    A user of the admin interface.
    TEXT

    field :email, String, null: false do
      description "The user's email address."
    end

    field :name, String, null: true do
      description "The user's display name."
    end
  end
end
