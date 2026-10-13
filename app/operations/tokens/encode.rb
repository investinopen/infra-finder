# frozen_string_literal: true

module Tokens
  # Encode a short-lived, purpose-specific JWT (e.g. an upload token).
  #
  # Unlike SJ, which signs with an RSA key from {SecurityConfig}, this signs
  # with a key derived from `secret_key_base`, so no extra secret is needed.
  #
  # @see Tokens::Decode
  class Encode
    include Dry::Monads[:result]

    ALGORITHM = "HS512"

    # @param [{ Symbol => Object }] payload
    # @return [Dry::Monads::Success(String)] the encoded token
    def call(payload)
      Success JWT.encode(payload, self.class.key, ALGORITHM)
    end

    class << self
      # @return [String]
      def key
        @key ||= Rails.application.key_generator.generate_key("tokens", 64)
      end
    end
  end
end
