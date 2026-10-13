# frozen_string_literal: true

module Middleware
  # Makes `request.remote_ip` use a client IP header set by the hosting
  # platform, such as App Platform's `do-connecting-ip`, when it is present.
  # Without the header, Rails' own `X-Forwarded-For` handling applies.
  #
  # @note Clients can send the header themselves. Only configure it where the
  #   platform's edge always overwrites it.
  # @see SystemConfig#client_ip_header
  class ClientAddress
    # @param [#call] app
    # @param [String, nil] header the HTTP header carrying the client IP
    def initialize(app, header:)
      @app = app
      @env_key = "HTTP_#{header.upcase.tr("-", "_")}" if header.present?
    end

    # @param [Hash] env
    # @return [Array]
    def call(env)
      client_ip = env[@env_key].presence if @env_key

      env["action_dispatch.remote_ip"] = client_ip if client_ip

      @app.call(env)
    end
  end
end
