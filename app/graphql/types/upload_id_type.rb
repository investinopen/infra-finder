# frozen_string_literal: true

module Types
  # A scalar type to represent an upload ID provided by the TUS infrastructure.
  class UploadIdType < Types::BaseScalar
    graphql_name "UploadID"

    description "An upload ID is used to refer to an upload within the tus infrastructure outside of the GraphQL API"

    class << self
      # Don't make the client do any parsing, accept `"/files/123456"` and produce `"123456"`
      # @param [String] input_value
      # @return [String, nil]
      def coerce_input(input_value, context)
        # simplecov:disable
        return nil if input_value.blank?
        # simplecov:enable

        File.basename(input_value)
      end

      # @param [#to_s] ruby_value
      # @return [String, nil]
      def coerce_result(ruby_value, context)
        ruby_value.to_s.presence
      end
    end
  end
end
