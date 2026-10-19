# frozen_string_literal: true

module Types
  # Shared metadata for image attachments
  #
  # @see ImageAttachments::Types::Metadata
  class ImageMetadataType < Types::BaseObject
    description "Shared metadata for image attachments"

    field :alt, String, null: true do
      description "Alt text for accessible images"
    end
  end
end
