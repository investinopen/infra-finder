# frozen_string_literal: true

require "shrine/storage/memory"
require "shrine/storage/s3"
require "shrine/storage/url"

aws_credentials = S3Config.to_h

bucket = UploadConfig.bucket

shared_s3_options = {
  bucket:,
  http_open_timeout: 30,
  retry_limit: 10,
  use_accelerate_endpoint: false,
  **aws_credentials
}

cache_s3_options = { **shared_s3_options, prefix: "cache" }
store_s3_options = { **shared_s3_options, prefix: "store" }
derivative_s3_options = { **shared_s3_options, prefix: "derivatives" }

Shrine.storages = {
  cache: Shrine::Storage::S3.new(**cache_s3_options),
  store: Shrine::Storage::S3.new(**store_s3_options),
  derivatives: Shrine::Storage::S3.new(**derivative_s3_options),
  remote: Shrine::Storage::Url,
}

if Rails.env.test?
  %i[cache store derivatives remote].each do |store|
    Shrine.storages[store] = Shrine::Storage::Memory.new
  end
end

Shrine.logger.level = Logger::WARN

Shrine.plugin :activerecord
Shrine.plugin :instrumentation
Shrine.plugin :backgrounding
Shrine.plugin :determine_mime_type, analyzer: :marcel, analyzer_options: { filename_fallback: true }
Shrine.plugin :type_predicates, methods: %i[pdf], mime: :marcel
Shrine.plugin :pretty_location, class_underscore: true
Shrine.plugin :data_uri
Shrine.plugin :tempfile # load it globally so that it overrides `Shrine.with_file`
Shrine.plugin :derivatives, create_on_promote: true, store: :derivatives
Shrine.plugin :upload_options, cache: { acl: "public-read" }, store: { acl: "public-read" }

if UploadConfig.has_mapped_host?
  Shrine.plugin(:url_options, **UploadConfig.for_url_options)
else
  Shrine.plugin(:url_options, cache: { public: true }, store: { public: true })
end

Shrine::Attacher.promote_block do
  atomic_promote
end

Shrine::Attacher.destroy_block do
  Processing::DestroyAttachmentJob.perform_later(self.class.name, data)
end
