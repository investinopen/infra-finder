# frozen_string_literal: true

module Support
  module Utility
    module Types
      extend Support::Typespace

      # A type for a hexadecimal string or an integer that can be converted to a hexadecimal string.
      #
      # @return [Dry::Types::Type(String, Integer)]
      HexValue = String.constrained(hexadecimal: true).constructor do |input|
        case input
        in Integer => i
          i.to_s(16)
        in Support::Constants::HEXADECIMAL => hex
          hex
        else
          raise Dry::Types::CoercionError, "Expected a hexadecimal string or an integer"
        end
      end

      # A type for an element in {EncodedUUID}.
      # @return [Dry::Types::Type(Integer)]
      EncodedUUIDElement = Integer.constrained(gt: 0)

      # @return [Dry::Types::Type(Integer, Integer, Integer, Integer, Integer)]
      EncodedUUID = Array.of(EncodedUUIDElement).constrained(size: 5)

      UUID = String.constrained(any_uuid: true)

      module Coercible
        # A coercible type for an element in {EncodedUUID}.
        #
        # @return [Dry::Types::Type(Integer)]
        EncodedUUIDElement = Support::Utility::Types::EncodedUUIDElement.constructor do |input|
          case input
          in Support::Utility::Types::Integer => i
            i
          in Support::Constants::HEXADECIMAL => hex
            # Handle initial 0s
            "1#{hex}".to_i(16)
          else
            raise Dry::Types::CoercionError, "Expected a hexadecimal string or an integer"
          end
        end

        # A coercible type for the 5-element tuple of integers that represents a UUID.
        #
        # @return [Dry::Types::Type(Integer, Integer, Integer, Integer, Integer)]
        EncodedUUID = Support::Utility::Types::EncodedUUID.constructor do |input|
          case input
          in Support::Utility::Types::EncodedUUID => encoded
            encoded
          in Support::Constants::ANY_UUID => uuid
            uuid.split(?-).map do |s|
              # Handle leading 0s since they won't encode with hashids
              "1#{s}".to_i(16)
            end
          else
            raise Dry::Types::CoercionError, "Expected an array of UUIDInt"
          end
        end
      end
    end
  end
end
