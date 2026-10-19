# frozen_string_literal: true

module ImageAttachments
  # This class wraps an {ImageUploader::Attacher} and presents it in a way
  # suitable for consumption by the GraphQL API.
  #
  # infra-finder: SJ's `BaseImageWrapper` and its site logo scope are folded in here,
  # since there is only one kind of image.
  #
  # @see ImageUploader
  # @see Types::ImageAttachmentType
  class ImageWrapper
    extend Dry::Initializer

    include Support::Typing

    param :attacher, ImageAttachments::Types::Attacher

    option :purpose, ImageAttachments::Types::Purpose, default: proc { "other" }

    delegate :file, to: :attacher, prefix: :original
    delegate :alt, :original_filename, to: :original_file, allow_nil: true

    # @return [Hash, nil]
    attr_reader :metadata

    # @return [ImageAttachments::OriginalWrapper]
    attr_reader :original

    # Returns the storage associated with the file.
    # @return [:cache, :store, :derivatives, :remote, nil]
    attr_reader :storage

    def initialize(...)
      super

      @metadata = original_file.try(:graphql_metadata)

      @original = OriginalWrapper.new self, original_file

      @storage = original_file.try(:storage_key)
    end

    ImageAttachments::Constants::IMAGE_SIZES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{name}
        @#{name} ||= SizeWrapper.new(self, ImageAttachments.image_size(#{name.inspect}))
      end
      RUBY
    end
  end
end
