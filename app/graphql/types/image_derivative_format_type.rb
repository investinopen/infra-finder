# frozen_string_literal: true

module Types
  # The format / MIME type of a specific image derivative.
  class ImageDerivativeFormatType < Types::BaseEnum
    description "The format / MIME type of a specific image derivative."

    value "WEBP", value: :webp do
      description <<~TEXT
      A more efficiently compressed image supported by most browsers worldwide.
      TEXT
    end

    value "PNG", value: :png do
      description <<~TEXT
      A Portable Network Graphics-formatted file, for legacy support on most all browsers.
      TEXT
    end
  end
end
