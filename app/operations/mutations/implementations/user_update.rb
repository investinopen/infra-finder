# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserUpdate
    class UserUpdate < VOGMutations::Implementation
      use_contract! :user_update
      use_contract! :mutate_user

      authorizes! :user, with: :update?

      # @param [User] user
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(user:, **attrs)
        assign_attributes!(user, **attrs)

        persist_model! user, attach_to: :user
      end
    end
  end
end
