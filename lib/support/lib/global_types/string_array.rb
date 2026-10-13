# frozen_string_literal: true

module Support
  module GlobalTypes
    # This is a typed subclass that represents a `text[]`.
    #
    # It is available to `StoreModel` objects as `:string_array`.
    class StringArray < AnyArray
      element_type Dry::Types["coercible.string"]

      # @!method cast(value)
      # Coerce a given value to an array of strings.
      # @note If any value fails, it will return an empty array instead.
      # @param [<#to_s>] value
      # @return [<String>]

      # @!attribute [r] type
      # @return [:string_array]
    end
  end
end
