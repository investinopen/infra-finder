# frozen_string_literal: true

# An uploader specifically for images, with common dimensions and formats.
class ImageUploader < Shrine
  ALLOWED_MIME_TYPES = %w[
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
  plugin :remote_url, max_size: 20.megabytes
  plugin :remove_invalid
  plugin :store_dimensions, analyzer: :ruby_vips
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data

  plugin :included do |name|
    delegate :alt, :graphql_metadata, :original_import_url, to: name, prefix: name, allow_nil: true

    class_eval <<~RUBY, __FILE__, __LINE__ + 1
    def #{name}_metadata
      #{name}&.graphql_metadata
    end

    def #{name}_metadata=(new_metadata)
      #{name}&.merge_graphql_metadata! new_metadata
    end
    RUBY
  end

  metadata_method :alt, :original_import_url

  add_metadata :sha256 do |io, derivative: nil, **|
    calculate_signature(io, :sha256, format: :base64) unless derivative
  end

  Attacher.validate do
    validate_mime_type ALLOWED_MIME_TYPES

    validate_max_size 20.megabytes

    InfraFinder::Container["attachments.check_image"].(file) do |m|
      m.success do
        # intentionally left blank
      end

      m.failure do |validation_errors|
        errors.concat validation_errors.to_a
      end
    end
  end

  Attacher.derivatives do |original|
    InfraFinder::Container["image_attachments.generate_derivatives"].call(original).value!
  end

  Attacher.promote_block do
    Processing::PromoteAttachmentJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
  end

  UploadedFile.include ImageAttachments::HasMetadata
end
