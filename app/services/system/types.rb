# frozen_string_literal: true

module System
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    BucketName = String.constrained(filled: true)

    S3Config = Instance(::S3Config)

    UploadConfig = Instance(::UploadConfig)
  end
end
