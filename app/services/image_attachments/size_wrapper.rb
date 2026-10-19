# frozen_string_literal: true

module ImageAttachments
  # Nested directly under {ImageAttachments::ImageWrapper}, this class conceptualizes
  # a size and wraps formats into discrete {ImageAttachments::DerivativeWrapper}s.
  #
  # @see Types::ImageSizeType
  class SizeWrapper
    include Support::Typing
    include Dry::Initializer[undefined: false].define -> do
      param :image_wrapper, ImageWrapper::Type
      param :size, ImageAttachments::Size
    end

    delegate :alt, :attacher, :original_filename, :purpose, to: :image_wrapper
    delegate :name, :width, :height, to: :size

    # @!attribute [r] png
    # @return [ImageAttachments::DerivativeWrapper]
    def png
      derivative_wrapper :png
    end

    # @!attribute [r] webp
    # @return [ImageAttachments::DerivativeWrapper]
    def webp
      derivative_wrapper :webp
    end

    private

    # @param [:webp, :png] format
    # @return [ImageAttachments::DerivativeWrapper]
    def derivative_wrapper(format)
      DerivativeWrapper.new self, format, uploaded_file_for(format)
    end

    # @param [:webp, :png] format
    # @return [Shrine::UploadedFile, nil]
    def uploaded_file_for(format)
      # simplecov:disable
      return nil if attacher.blank?
      # simplecov:enable

      attacher.get name, format
    end
  end
end
