# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ViewerRefreshToken
    class ViewerRefreshToken < VOGMutations::Implementation
      include Common::Deps[
        issue_token: "users.tokens.issue",
        revoke_token: "users.tokens.revoke",
      ]

      authorizes! :current_user, with: :manage_own_session?

      # @return [void]
      def call(**)
        viewer_token = check_result!(issue_token.(current_user))

        check_result!(revoke_token.(current_user, graphql_context[:token_payload]))

        attach! :viewer_token, viewer_token
      end
    end
  end
end
