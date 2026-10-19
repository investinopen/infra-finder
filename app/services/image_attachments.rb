# frozen_string_literal: true

# An interface for dealing with image attachments in GraphQL.
#
# @see ImageAttachments::ImageWrapper
module ImageAttachments
  extend Dry::Container::Mixin

  register :formats, memoize: true do
    Constants::FORMATS.dup
  end

  register :sizes, memoize: true do
    Constants::IMAGE_SIZES.each_with_object({}) do |(size, (width, height)), h|
      h[size] = ImageAttachments::Size.new(name: size, width:, height:)
    end.freeze
  end

  class << self
    # @yieldparam [Symbol] format
    # @yieldreturn [void]
    def each_format
      return enum_for(__method__) unless block_given?

      self[:formats].each do |format|
        yield format
      end

      return self
    end

    # @yieldparam [ImageAttachments::Size] size
    # @yieldreturn [void]
    def each_image_size
      return enum_for(__method__) unless block_given?

      self[:sizes].each_value do |size|
        yield size
      end

      return self
    end

    # @param [Symbol] name
    # @return [ImageAttachments::Size]
    def image_size(name)
      self[:sizes].fetch name
    end
  end
end
