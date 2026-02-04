# frozen_string_literal: true

# An uploader specifically for {ImportSource}s.
class ImportSourceUploader < Shrine
  plugin :add_metadata
  plugin :refresh_metadata
  plugin :signature
  plugin :validation_helpers
  plugin :restore_cached_data

  add_metadata :sha256 do |io, **|
    calculate_signature(io, :sha256, format: :base64)
  end

  Attacher.validate do
    validate_mime_type %w[text/csv]
  end

  Attacher.promote_block do
    promote
  end
end
