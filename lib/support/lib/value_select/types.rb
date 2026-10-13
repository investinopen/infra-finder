# frozen_string_literal: true

module Support
  module ValueSelect
    module Types
      extend Support::Typespace

      AffectedRows = Coercible::Integer.default(0).constrained(gteq: 0)

      # A type representing a hash of casts that will be applied to the value lists.
      Casts = Hash.map(Coercible::Symbol, Coercible::Symbol)

      # A type matching a string that acts as the table name for the selected value list query.
      TableName = Coercible::String.constrained(filled: true, rails_present: true).default("tbl")

      # A type representing a list of unique attributes to merge / upsert by.
      UniqueBy = Array.of(Symbol).constrained(min_size: 1)

      # A type representing a single "row" in a value list.
      Value = Hash.map(Coercible::Symbol, Any).constrained(min_size: 1)

      # A type representing a list of {Value}s.
      Values = Array.of(Value)
    end
  end
end
