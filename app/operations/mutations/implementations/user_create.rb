# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserCreate
    class UserCreate < VOGMutations::Implementation
      use_contract! :user_create
      use_contract! :mutate_user

      authorizes! :user, with: :create?

      # @param [User] user
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(user:, **attrs)
        assign_attributes!(user, **attrs)

        persist_model! user, attach_to: :user
      end

      before_prepare def initialize_user!
        args[:user] = User.new
      end
    end
  end
end
