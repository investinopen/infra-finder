# frozen_string_literal: true

module Utility
  class ValidateUploadContentType
    include Dry::Monads[:result]

    # @param [Hash] data
    # @param [<String>] content_types
    # @return [Dry::Monads::Result]
    def call(data, *content_types)
      content_types.flatten!

      enum = AppTypes::Coercible::String.enum(*content_types)

      uploaded_file = Shrine::UploadedFile.new(data)

      actual = Shrine.determine_mime_type(uploaded_file)

      # simplecov:disable
      return Failure[:unknown_content_type] if actual.blank?
      # simplecov:enable

      enum.try(actual).to_monad
    rescue Shrine::Error => e
      # simplecov:disable
      Failure[:shrine_error, e.message]
      # simplecov:enable
    end
  end
end
