# frozen_string_literal: true

module Users
  # Authenticate a GraphQL API request from its `Authorization: Bearer` header.
  #
  # Requests without the header are anonymous. A token must decode, be on the
  # allowlist, and belong to a user who may still sign in.
  #
  # @see GraphQLController#authenticate_user!
  class Authenticate
    include Dry::Monads[:result]

    BEARER = /\ABearer\s+(?<token>\S+)\z/i

    # @param [Hash] env a Rack environment, generally acquired from `request.env`
    # @return [Dry::Monads::Success((User, Hash))] the user and the decoded token payload
    # @return [Dry::Monads::Success((AnonymousUser, nil))] when no token was provided
    # @return [Dry::Monads::Failure(:expired)]
    # @return [Dry::Monads::Failure(:invalid)]
    # @return [Dry::Monads::Failure(:inactive)] when the user can no longer sign in
    def call(env)
      header = env["HTTP_AUTHORIZATION"]

      return Success[AnonymousUser.new, nil] if header.blank?

      token = BEARER.match(header)&.[](:token)

      return Failure[:invalid] if token.blank?

      payload = Warden::JWTAuth::TokenDecoder.new.call(token)

      user = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)

      return Failure[:inactive] unless Users::Access.allowed?(user)

      Success[user, payload]
    rescue JWT::ExpiredSignature
      Failure[:expired]
    rescue JWT::DecodeError
      Failure[:invalid]
    end
  end
end
