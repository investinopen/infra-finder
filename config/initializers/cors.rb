# frozen_string_literal: true

module CORSHelper
  METHODS = %i[get post patch put delete options head].freeze
  S3MP_HEADERS = %w[Authorization Content-Type x-amz-content-sha256 x-amz-date Upload-Token].freeze
  S3MP_EXPOSED = %w[ETag].freeze
  # Paths that only the admin SPA's origin may call.
  ADMIN_SPA_PATHS = %r{\A/(?:graphql|files|oauth|\.well-known)(?:/|\z)}

  TUS_EXPOSED = %w[
    Location
    Upload-Concat Upload-Defer-Length Upload-Length Upload-Metadata Upload-Offset
    Tus-Version Tus-Resumable Tus-Max-Size Tus-Extension
  ].freeze
end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # The GraphQL API, tus uploads, and the OpenID Provider endpoints the SPA
  # calls with fetch only accept the admin SPA's origin, when one is configured.
  allow do
    origins LocationsConfig.admin_spa_origin

    resource "/.well-known/openid-configuration", headers: :any, methods: %i[get options]

    resource "/oauth/discovery/keys", headers: :any, methods: %i[get options]

    resource "/oauth/revoke", headers: :any, methods: %i[post options]

    resource "/oauth/token", headers: :any, methods: %i[post options]

    resource "/oauth/userinfo", headers: :any, methods: %i[get post options]

    resource "/graphql", headers: :any, methods: %i[post options]

    resource "/files", headers: :any, methods: CORSHelper::METHODS,
      expose: CORSHelper::TUS_EXPOSED

    resource "/files/*", headers: :any, methods: CORSHelper::METHODS,
      expose: CORSHelper::TUS_EXPOSED
  end

  allow do
    origins ?*

    resource "/s3/multipart/*", headers: CORSHelper::S3MP_HEADERS, methods: CORSHelper::METHODS,
      expose: CORSHelper::S3MP_EXPOSED

    resource ?*, headers: :any, methods: CORSHelper::METHODS,
      if: proc { |env| !CORSHelper::ADMIN_SPA_PATHS.match?(env["PATH_INFO"]) }
  end
end
