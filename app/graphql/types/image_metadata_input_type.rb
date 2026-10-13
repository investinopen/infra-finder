# frozen_string_literal: true

module Types
  # An input type for shared metadata when updating image attachments.
  class ImageMetadataInputType < Types::HashInputObject
    description "Shared metadata for updating image attachments"

    argument :alt, String, required: false do
      description "Alt text for accessible images"
    end
  end
end
