# frozen_string_literal: true

module Attachments
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    UploadedFile = Instance(::Shrine::UploadedFile)
  end
end
