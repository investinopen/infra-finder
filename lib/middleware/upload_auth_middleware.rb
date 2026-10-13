# frozen_string_literal: true

require "dry/monads/result"
require "dry/matcher/result_matcher"

module Middleware
  # Guards the tus upload endpoint, letting CORS preflight requests through.
  #
  # @see Uploads::Authorize
  class UploadAuthMiddleware
    include Dry::Matcher.for(:authorize, with: Dry::Matcher::ResultMatcher)
    include Dry::Monads[:result]

    # @param [#call] app
    def initialize(app)
      @app = app
    end

    # @param [Hash] env
    # @return [Array] a Rack response
    def call(env)
      req = Rack::Request.new(env)

      return @app.call(env) if req.options?

      authorize(env) do |m|
        m.success do
          @app.call(env)
        end

        m.failure do
          build_forbidden_response
        end
      end
    end

    private

    # @param [Hash] env
    # @return [Dry::Monads::Result] (@see Uploads::Authorize#call)
    def authorize(env)
      Common::Container["uploads.authorize"].call(env)
    end

    # @return [Array] a 403 Rack response
    def build_forbidden_response
      headers = {
        "Content-Type" => "application/json"
      }

      body = {
        errors: [
          { message: "Not Authorized For Uploads" }
        ]
      }

      [
        403,
        headers,
        [body.to_json]
      ]
    end
  end
end
