# frozen_string_literal: true

module ImageAttachments
  # Generate a derivative in each format for each image size.
  #
  # @see ImageAttachments.each_image_size
  class GenerateDerivatives
    include Dry::Monads[:result]

    # @param [IO] original
    # @return [Dry::Monads::Success({ Symbol => { Symbol => Tempfile } })]
    def call(original)
      vips = ImageProcessing::Vips.source(original)

      derivatives = ImageAttachments.each_image_size.each_with_object({}) do |size, sizes|
        resized = vips.resize_to_limit(size.width, size.height)

        sizes[size.name] = ImageAttachments.each_format.to_h do |format|
          [format.to_sym, resized.convert!(format.to_s)]
        end
      end

      Success derivatives
    end
  end
end
