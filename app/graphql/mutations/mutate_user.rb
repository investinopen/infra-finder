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

    shared_argument_set Mutations::Shared::UserData

    argument :admin, Boolean, required: false do
      description <<~TEXT
      Whether the user is an admin.
      TEXT
    end

    argument :super_admin, Boolean, required: false do
      description <<~TEXT
      Whether the user is a super admin.
      TEXT
    end

    argument :comment_notifications, Types::SubscriptionType, required: false do
      description <<~TEXT
      Whether the user is emailed about comments.
      TEXT
    end

    argument :solution_notifications, Types::SubscriptionType, required: false do
      description <<~TEXT
      Whether the user is emailed about solution workflow changes.
      TEXT
    end
  end
end
