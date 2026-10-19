# frozen_string_literal: true

module ImageAttachments
  # Constants used by the {ImageAttachments} subsystem.
  #
  # @api private
  module Constants
    extend ActiveSupport::Concern

    # The actual formats we render our variants in.
    FORMATS = %i[webp png].freeze

    # Dimensions that are used for images in the system.
    #
    # @see ImageAttachments.image_size
    # @see ImageAttachments::ImageWrapper
    IMAGE_SIZES = {
      thumb:    [200, 200],
      small:    [300, 300],
      medium:   [500, 500],
      large:    [800, 800],
    }.freeze
  end
end
