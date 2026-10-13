# frozen_string_literal: true

module Tokens
  # Decode a JWT created by {Tokens::Encode}.
  class Decode
    include Dry::Monads[:result]

    # @param [String] token
    # @param [String, nil] aud
    # @param [String, nil] sub
    # @param [Boolean] verify_expiration
    # @return [Dry::Monads::Success(Hash)] the decoded token payload
    # @return [Dry::Monads::Failure(:invalid_token, String)] if the token is otherwise invalid
    # @return [Dry::Monads::Failure(:expired, String)] if the token is expired
    # @return [Dry::Monads::Failure(:no_token_provided, String)] if no token is provided
    def call(token, aud: nil, sub: nil, verify_expiration: true)
      return Failure[:no_token_provided, "No token provided"] if token.blank?

      options = { algorithm: Tokens::Encode::ALGORITHM, verify_expiration: }

      options.merge!(aud:, verify_aud: true) if aud.present?

      options.merge!(sub:, verify_sub: true) if sub.present?

      payload, _headers = JWT.decode token, Tokens::Encode.key, true, options

      Success payload
    rescue JWT::ExpiredSignature => e
      Failure[:expired, e.message]
    rescue JWT::DecodeError => e
      Failure[:invalid_token, e.message]
    end
  end
end
