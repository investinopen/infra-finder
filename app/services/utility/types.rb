# frozen_string_literal: true

module Utility
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    SessionID = Types::String.constructor do |value|
      case value
      when Rack::Session::SessionId
        value.public_id
      when String
        value
      else
        # :nocov:
        raise Dry::Types::CoercionError, "invalid session id: #{value.inspect}"
        # :nocov:
      end
    end.constrained(format: /\A[0-9a-f]+\z/i)
  end
end
