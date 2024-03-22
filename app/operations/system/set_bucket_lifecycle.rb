# frozen_string_literal: true

module System
  class SetBucketLifecycle
    include Dry::Monads[:result, :do]

    LIFECYCLE_CONFIGURATION = {
      rules: [
        {
          id: "PruneOldAssets",
          filter: {
            and: {
              prefix: "assets/",
              tags: [
                key: "prunable",
                value: "true",
              ],
            },
          },
          status: "Enabled",
          expiration: {
            days: 30,
          },
        },
        {
          id: "PruneShrineCache",
          filter: {
            prefix: "cache/",
          },
          status: "Enabled",
          expiration: {
            days: 14,
          },
        },
      ],
    }.freeze

    def call
      bucket = UploadConfig.bucket

      client = S3Config.build_s3_client

      client.put_bucket_lifecycle_configuration(bucket:, lifecycle_configuration: LIFECYCLE_CONFIGURATION)

      Success()
    end
  end
end
