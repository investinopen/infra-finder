# frozen_string_literal: true

module Users
  # Authenticate a GraphQL API request from its `Authorization: Bearer` header.
  #
  # Requests without the header are anonymous. A token must be a current
  # Doorkeeper access token with the `openid` scope, and belong to a user who
  # may still sign in.
  #
  # @see GraphQLController#authenticate_user!
  class Authenticate
    include Dry::Monads[:result]

    # @param [Hash] env a Rack environment, generally acquired from `request.env`
    # @return [Dry::Monads::Success((User, OAuth::AccessToken))] the user and their access token
    # @return [Dry::Monads::Success((AnonymousUser, nil))] when no token was provided
    # @return [Dry::Monads::Failure(:expired)]
    # @return [Dry::Monads::Failure(:invalid)]
    # @return [Dry::Monads::Failure(:inactive)] when the user can no longer sign in
    def call(env)
      return Success[AnonymousUser.new, nil] if env["HTTP_AUTHORIZATION"].blank?

      # This also revokes the previous refresh token in the token session,
      # now that its replacement is in use.
      token = Doorkeeper::OAuth::Token.authenticate(ActionDispatch::Request.new(env), :from_bearer_authorization)

      return Failure[:invalid] if token.nil? || token.revoked? || !token.includes_scope?("openid")

      return Failure[:expired] if token.expired? || token.session_ended?

      user = User.find_by(id: token.resource_owner_id)

      return Failure[:invalid] if user.nil?

      return Failure[:inactive] unless Users::Access.allowed?(user)

      Success[user, token]
    end
  end
end
