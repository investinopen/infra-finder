# frozen_string_literal: true

module ImageAttachments
  # Types related to working with image attachments.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    extend Constants

    # A positive (non-zero) dimension for height or width.
    Dimension = Integer.constrained(gt: 0)

    # @see ImageAttachments::Constants::FORMATS
    Format = Coercible::Symbol.enum(*Constants::FORMATS)

    # @see ImageUploader
    Attacher = Instance(ImageUploader::Attacher)

    # @see ImageAttachments::Constants::IMAGE_SIZES
    Size = Coercible::Symbol.enum(*Constants::IMAGE_SIZES.keys)

    # @see ImageUploader
    UploadedFile = Instance(ImageUploader::UploadedFile)

    # The "purpose" a given image attachment serves
    #
    # @see Types::ImagePurposeType
    Purpose = ::Types::ImagePurposeType.dry_type.fallback("other")

    # A hash type for matching image attachment metadata
    Metadata = Coercible::Hash.schema(
      alt?: String.optional,
    ).with_key_transform(&:to_sym)
  end
end
