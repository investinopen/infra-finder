# frozen_string_literal: true

module ImageAttachments
  # An operation that sanitizes image metadata.
  # @see ImageAttachments::Types::Metadata
  class SanitizeMetadata
    # @param [Hash{String => Object}] value
    # @return [Hash{String => Object}, nil]
    def call(value)
      ImageAttachments::Types::Metadata[value].deep_stringify_keys.compact
    rescue Dry::Types::CoercionError
      # simplecov:disable
      nil
      # simplecov:enable
    end
  end
end
