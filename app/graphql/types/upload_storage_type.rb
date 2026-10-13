# frozen_string_literal: true

module Types
  # An enum representing the different storage types for user uploads.
  #
  # In practice, there's only one option: `CACHE`, which is temporary storage.
  class UploadStorageType < Types::BaseEnum
    description "The name of a storage that can contain user uploads. There's only one option at present."

    value "CACHE", value: :cache do
      description <<~TEXT
      Temporary storage. Cleaned on a regular basis if uploads are not attached anywhere.
      TEXT
    end
  end
end
