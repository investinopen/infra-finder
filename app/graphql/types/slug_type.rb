# frozen_string_literal: true

module Types
  # A custom GraphQL scalar type for encoded, youtube-style slugs.
  class SlugType < Types::BaseScalar
    description <<~TEXT
    A slug that can identify a record in context.

    Slugs are encoded strings that map to internal record IDs.
    TEXT

    class << self
      # @param [String] input_value
      # @param [GraphQL::Query::Context] context
      # @return [String, nil]
      def coerce_input(input_value, context)
        case input_value
        when AnonymousUser::ID then AnonymousUser::ID
        else
          Support::System["slugs.decode_id"].call(input_value).value_or do
            raise GraphQL::CoercionError, "#{input_value.inspect} is not a valid slug"
          end
        end
      end

      # @param [String] ruby_value
      # @param [GraphQL::Query::Context] context
      # @return [String, nil]
      def coerce_result(ruby_value, context)
        case ruby_value
        when AnonymousUser::ID then AnonymousUser::ID
        else
          Support::System["slugs.encode_id"].call(ruby_value).value_or do
            # We explicitly do not expose `ruby_value` in the error message.
            raise GraphQL::CoercionError, "cannot produce a valid slug for this record"
          end
        end
      end
    end
  end
end
