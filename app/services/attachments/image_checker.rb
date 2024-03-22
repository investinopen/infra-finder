# frozen_string_literal: true

module Attachments
  class ImageChecker < Support::SimpleMonadicValidator
    include Dry::Initializer[undefined: false].define -> do
      param :file, Types::UploadedFile
    end

    attr_reader :tempfile

    check! :processable do
      vips = ImageProcessing::Vips.source(tempfile.path).convert("png")

      result = vips.saver(quality: 100).resize_to_limit!(100, 100)
    rescue Vips::Error
      Invalid("is not processable")
    else
      File.unlink result.path

      Valid("is processable")
    end

    around_check :download!

    private

    def download!
      file.download do |tmp|
        @tempfile = tmp

        yield
      end
    ensure
      @tempfile = nil
    end
  end
end
