# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::UserCreate
  # @see Mutations::UserUpdate
  class MutateUser < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `userCreate` and `userUpdate`.
    TEXT

    field :user, Types::UserType, null: true do
      description <<~TEXT
      The newly-modified user, if successful.
      TEXT
    end

    argument :email, String, required: false do
      description "The user's email address."
    end

    argument :name, String, required: false do
      description "The user's display name."
    end

    argument :admin, Boolean, required: false do
      description "Whether the user is an admin."
    end

    argument :super_admin, Boolean, required: false do
      description "Whether the user is a super admin."
    end

    argument :password, String, required: false do
      description "A new password. Changing it signs the user out of the API everywhere."
    end

    argument :password_confirmation, String, required: false do
      description "Must match `password`."
    end

    argument :comment_notifications, Types::SubscriptionType, required: false do
      description "Whether the user is emailed about comments."
    end

    argument :solution_notifications, Types::SubscriptionType, required: false do
      description "Whether the user is emailed about solution workflow changes."
    end
  end
end
