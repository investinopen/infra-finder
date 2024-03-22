# frozen_string_literal: true

module System
  class AssetPusher < Support::HookBased::Actor
    include Dry::Effects::Handler.Parallel(executor: :io)
    include Dry::Effects.Parallel
    include Dry::Initializer[undefined: false].define -> do
      option :upload_config, Types::UploadConfig, default: proc { UploadConfig.new }
      option :logger, Types.Instance(::Logger), default: proc { Logger.new($stdout) }
    end

    standard_execution!

    ASSETS_PATH = Rails.public_path.join("assets")

    MANIFEST_PATH = ASSETS_PATH.join(".manifest.json")

    KEY_PREFIX = "assets"

    delegate :bucket, to: :upload_config

    # @return [Aws::S3::Bucket]
    attr_reader :bucket_client

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :manifest

    # @return [<String>]
    attr_reader :manifest_keys

    # @return [Aws::S3::Client]
    attr_reader :s3_client

    def call
      run_callbacks :execute do
        yield prepare!

        yield push!

        yield prune!
      end

      Success()
    end

    wrapped_hook! def prepare
      return Failure[:assets_not_precompiled] unless MANIFEST_PATH.exist?

      @bucket_client = upload_config.build_client

      @s3_client = upload_config.s3.build_s3_client

      @manifest = JSON.parse(MANIFEST_PATH.read).with_indifferent_access

      @manifest_keys = manifest.values.map { File.join(KEY_PREFIX, _1) }

      super
    end

    wrapped_hook! def push
      uploads = []

      ASSETS_PATH.find do |path|
        next unless path.file?

        upload = par do
          key = path.relative_path_from(Rails.public_path).to_s

          name = path.basename.to_s

          content_type = Marcel::MimeType.for(path, name:)

          path.open("r+") do |body|
            bucket_client.put_object(key:, body:, content_type:, acl: "public-read", tagging: "prunable=false")
          end

          logger.debug "Uploaded #{key}"
        end

        uploads << upload
      end

      join uploads

      super
    end

    around_push :with_parallel

    wrapped_hook! def prune
      bucket_client.objects(prefix: KEY_PREFIX).each_slice(100) do |batch|
        prune_batch! batch
      end

      super
    end

    around_prune :with_parallel

    private

    def prune_batch!(batch)
      prunings = batch.map do |obj|
        par { prune_obj(obj) }
      end

      join prunings
    end

    def prune_obj(obj)
      key = obj.key

      return if key == "assets/.manifest.json" || key.in?(manifest_keys)

      logger.debug "Marking un-manifested asset #{key} as prunable"

      s3_client.put_object_tagging(
        bucket:,
        key:,
        tagging: {
          tag_set: [
            {
              key: "prunable",
              value: "true",
            },
          ],
        },
      )
    end
  end
end
