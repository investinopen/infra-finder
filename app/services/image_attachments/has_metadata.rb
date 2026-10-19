# frozen_string_literal: true

module ImageAttachments
  # A mixin that adds specific metadata handling to shrine uploaders.
  module HasMetadata
    extend ActiveSupport::Concern

    # @return [{ String => Object }]
    def graphql_metadata
      metadata.slice("alt")
    end

    # @see ImageAttachments::SanitizeMetadata
    # @param [Hash{String => Object}] new_metadata
    # @return [void]
    def merge_graphql_metadata!(new_metadata)
      sanitized = Common::Container["image_attachments.sanitize_metadata"].call new_metadata

      add_metadata sanitized
    end
  end
end
