# frozen_string_literal: true

module ImageAttachments
  # A wrapper for the original image, if present.
  #
  # @see Types::ImageOriginalType
  class OriginalWrapper
    include Dry::Initializer[undefined: false].define -> do
      param :image_wrapper, ImageWrapper::Type
      param :uploaded_file, ImageAttachments::Types::UploadedFile.optional, optional: true
    end

    delegate :height, :mime_type, :width, to: :uploaded_file, allow_nil: true
    delegate :alt, :original_filename, :purpose, to: :image_wrapper

    # @!attribute [r] storage
    # Returns the storage associated with the file.
    # @return [:cache, :store, :derivatives, :remote, nil]
    def storage
      uploaded_file&.storage_key
    end

    # @return [String, nil]
    def url(**url_options)
      # simplecov:disable
      return if uploaded_file.blank?
      # simplecov:enable

      uploaded_file.url(**url_options)
    end
  end
end
