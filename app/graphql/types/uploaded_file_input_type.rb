# frozen_string_literal: true

module Types
  # A GraphQL input type for an uploaded file.
  #
  # @see Types::UploadedFileMetadataInputType
  # @see Types::UploadIdType
  # @see Types::UploadStorageType
  class UploadedFileInputType < Types::HashInputObject
    description "A definition for a file upload"

    argument :id, Types::UploadIdType, required: true do
      description <<~TEXT
      The ID of the uploaded file, as returned by TUS.
      TEXT
    end

    argument :storage, Types::UploadStorageType, required: false, default_value: :cache do
      description <<~TEXT
      The storage that contains the input.
      TEXT
    end

    argument :metadata, Types::UploadedFileMetadataInputType, required: false do
      description <<~TEXT
      Metadata to associate with the upload
      TEXT
    end
  end
end
