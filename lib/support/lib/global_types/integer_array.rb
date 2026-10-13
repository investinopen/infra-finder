# frozen_string_literal: true

module Support
  module GlobalTypes
    # This is a typed subclass that represents an `int[]`.
    #
    # It is available to `StoreModel` objects as `:integer_array`.
    class IntegerArray < AnyArray
      element_type Dry::Types["coercible.integer"]

      # @!method cast(value)
      # Coerce a given value to an array of integers.
      # @note If any value fails, it will return an empty array instead.
      # @param [<#to_i>] value
      # @return [<Integer>]

      # @!attribute [r] type
      # @return [:integer_array]
    end
  end
end
