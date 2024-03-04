# frozen_string_literal: true

class UploadConfig < ApplicationConfig
  # A pattern that matches a URI that doesn't end in a trailing slash.
  SANS_TRAILING_SLASH = %r{(?<!/)\z}

  attr_config bucket: "infra-finder-storage", public: false

  attr_config :mapped_host

  delegate :endpoint, :force_path_style, to: :s3

  coerce_types public: :boolean

  def has_mapped_host?
    endpoint.present? && bucket.present? && force_path_style
  end

  # A combination of {#endpoint} and {#bucket}, with a trailing slash.
  #
  # @return [String]
  memoize def host
    return unless has_mapped_host?

    joined = URI.join mapped_host, bucket

    joined.to_s.sub(SANS_TRAILING_SLASH, ?/)
  end

  # @!attribute [r] s3
  # @return [S3Config]
  memoize def s3
    S3Config.new
  end

  memoize def for_url_options
    return {} unless has_mapped_host?

    base = { host:, public:, }

    cache = { **base }
    store = { **base }

    {
      cache:,
      store:
    }
  end
end
