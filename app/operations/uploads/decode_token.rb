# frozen_string_literal: true

module Uploads
  # Decodes an upload token created with {Uploads::EncodeToken}.
  #
  # @see Tokens::Decode
  class DecodeToken
    include Dry::Monads[:result]
    include Common::Deps[decode: "tokens.decode"]

    # @param [String] raw_token
    # @return [Dry::Monads::Success(Hash)] (@see Tokens::Decode#call)
    # @return [Dry::Monads::Failure(Symbol, String)]
    def call(raw_token)
      decode.call raw_token, aud: "upload"
    end
  end
end
