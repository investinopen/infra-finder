# frozen_string_literal: true

module StoredMessages
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Level = Coercible::String.default("debug").enum("debug", "info", "warn", "error", "fatal", "unknown").fallback("unknown")

    Record = Instance(::HasStoredMessages)
  end
end
