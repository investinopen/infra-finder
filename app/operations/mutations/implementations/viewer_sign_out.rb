# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ViewerSignOut
    class ViewerSignOut < VOGMutations::Implementation
      include Common::Deps[
        revoke_token: "users.tokens.revoke",
      ]

      authorizes! :current_user, with: :manage_own_session?

      # @return [void]
      def call(**)
        check_result!(revoke_token.(current_user, graphql_context[:token_payload]))

        attach! :signed_out, true
      end
    end
  end
end
