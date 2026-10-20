# frozen_string_literal: true

module Uploads
  # A service that authorizes rack requests for upload access.
  # It allows a variable number of headers to be provided, for
  # use with tus.js via `Upload-Token` or through a GraphQL API
  # bearer token on `Authorization`.
  class Authorize
    include Dry::Monads[:result, :do]
    include MonadicFind
    include Common::Deps[
      authenticate_bearer: "users.authenticate",
      decode_upload_token: "uploads.decode_token",
    ]

    # Header(s) that can be provided by a tus client or similar.
    TOKEN_HEADERS = %w[HTTP_UPLOAD_TOKEN].freeze

    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(User, SolutionIntake)]
    # @return [Dry::Monads::Failure(:unauthorized, String)]
    def call(env)
      try_intake_token(env).or do
        authorize_user(env)
      end
    end

    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:unauthorized, String)]
    def authorize_user(env)
      user = yield authenticate env

      yield authorize user

      env["uploads.user"] = user

      Success user
    end

    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:unauthorized, String)]
    def authenticate(env)
      try_upload_tokens(env).or do
        try_bearer env
      end.or do
        unauthorized
      end
    end

    # @param [User] user the user to authorize
    # @return [Dry::Monads::Success(true)]
    # @return [Dry::Monads::Failure(:unauthorized, String)]
    def authorize(user)
      if user.has_any_upload_access?
        Success true
      else
        unauthorized
      end
    end

    # @param [String] id
    # @see MonadicFind#monadic_find_by
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:record_not_found, String)]
    def find_user(id)
      monadic_find_by(User, id:)
    end

    # @see Users::Authenticate
    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:anonymous)]
    # @return [Dry::Monads::Failure(Symbol)]
    def try_bearer(env)
      authenticate_bearer.(env).bind do |(user, _payload)|
        user.anonymous? ? Failure[:anonymous] : Success(user)
      end
    end

    # A method that will iterate through {TOKEN_HEADERS} and attempt
    # to authenticate a user based on any upload token provided.
    #
    # @see #try_upload_token
    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:unavailable, String)]
    def try_upload_tokens(env)
      start = Failure()

      TOKEN_HEADERS.reduce start do |result, header|
        result.or do
          try_upload_token(env, header)
        end
      end
    end

    # @param [{ String => String }] env the request environment
    # @param [String] header the header to check for an upload token (@see TOKEN_HEADERS)
    # @return [Dry::Monads::Success(User)]
    # @return [Dry::Monads::Failure(:unavailable, String)]
    def try_upload_token(env, header)
      token = env[header]

      return Failure[:unavailable, "Header #{header.inspect} unavailable"] if token.blank?

      payload = yield decode_upload_token.call token

      user = yield find_user payload["sub"]

      yield check_session(user, payload["sid"])

      Success user
    end

    # An upload token is only valid while the token session it was issued
    # under is active (not signed out, revoked, or past its lifetime).
    #
    # @param [User] user
    # @param [String, nil] session_id
    # @return [Dry::Monads::Success(true)]
    # @return [Dry::Monads::Failure(:revoked_session, String)]
    def check_session(user, session_id)
      if OAuth::AccessToken.session_active?(user, session_id)
        Success true
      else
        Failure[:revoked_session, "The session for this upload token has ended"]
      end
    end

    # An intake upload token lets anyone filling in the intake upload, while the intake
    # can still be updated.
    #
    # @see Uploads::EncodeIntakeToken
    # @param [{ String => String }] env the request environment
    # @return [Dry::Monads::Success(SolutionIntake)]
    # @return [Dry::Monads::Failure(Symbol, String)]
    def try_intake_token(env)
      token = env["HTTP_UPLOAD_TOKEN"]

      return Failure[:unavailable, "No upload token"] if token.blank?

      payload = yield decode_upload_token.call token

      return Failure[:not_an_intake_token, "Not an intake upload token"] unless payload.key?("iid")

      intake = yield monadic_find_by(SolutionIntake, id: payload["iid"])

      return unauthorized unless SolutionIntakePolicy.new(intake, user: nil).apply(:update?)

      env["uploads.solution_intake"] = intake

      Success intake
    end

    # @return [Dry::Monads::Failure(:unauthorized, String)]
    def unauthorized
      Failure[:unauthorized, "No access to upload"]
    end
  end
end
