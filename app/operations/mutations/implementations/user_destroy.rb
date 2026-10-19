# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserDestroy
    class UserDestroy < VOGMutations::Implementation
      use_contract! :user_destroy

      authorizes! :user, with: :destroy?

      # @param [User] user
      # @return [void]
      def call(user:)
        destroy_model! user, auth: true
      end
    end
  end
end
