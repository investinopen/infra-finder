# frozen_string_literal: true

# An uploader specifically for images, with common dimensions and formats.
class ImageUploader < Shrine
  ALLOWED_MIME_TYPES = %w[
    image/heic
    image/heif
    image/jpeg
    image/jpg
    image/png
    image/svg+xml
    image/tiff
    image/webp
  ].freeze

  ACCEPT = [
    ".jpeg", ".png", ".jpg", ".svg", ".webp", *ALLOWED_MIME_TYPES
  ].join(?,).freeze

  plugin :derivatives, create_on_promote: false
  plugin :add_metadata
  plugin :default_url
  plugin :refresh_metadata
  plugin :remote_url, max_size: 100.megabytes
  plugin :store_dimensions, analyzer: :ruby_vips
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data

  plugin :included do |name|
    delegate :alt, to: name, prefix: name, allow_nil: true
  end

  metadata_method :alt

  add_metadata :sha256 do |io, derivative: nil, **|
    calculate_signature(io, :sha256, format: :base64) unless derivative
  end

  Attacher.validate do
    validate_mime_type ALLOWED_MIME_TYPES
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    {
      thumb: vips.resize_to_limit!(200, 200),
      small: vips.resize_to_limit!(300, 300),
      medium: vips.resize_to_limit!(500, 500),
      large: vips.resize_to_limit!(800, 800),
    }
  end
end
