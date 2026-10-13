# frozen_string_literal: true

module Searching
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Attribute = Coercible::Symbol.constrained(format: /\A[a-z_][a-z0-9_]*\z/)

    ColumnName = Attribute

    ColumnNames = Types::Array.of(ColumnName).constrained(min_size: 1)

    ContextName = Attribute

    Needle = Coercible::String.optional

    ScopeName = Attribute

    Strategy = ::Types::SearchStrategyType.dry_type.fallback("fuzzy")
  end
end
