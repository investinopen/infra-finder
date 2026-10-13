# frozen_string_literal: true

module Uploads
  # Generate a token that can be provided on the Upload-Token header,
  # for use with uppy / tus.js clients.
  #
  # Unlike SJ, the token records the API token (session) it was issued under,
  # and {Uploads::Authorize} rejects it once that session is revoked.
  class EncodeToken
    include Dry::Monads[:result]
    include Common::Deps[encode: "tokens.encode"]

    # @param [User] user
    # @param [String, nil] session_jti the `jti` of the API token the upload token is issued under
    # @return [Dry::Monads::Success(String)] the upload token
    # @return [Dry::Monads::Failure(:no_upload_access, User)]
    # @return [Dry::Monads::Failure(:no_session)]
    def call(user, session_jti:)
      return Failure[:no_upload_access, user] unless user.has_any_upload_access?

      return Failure[:no_session] if session_jti.blank?

      exp = 5.hours.from_now.to_i

      encode.call(sub: user.id, sid: session_jti, aud: "upload", exp:)
    end
  end
end
