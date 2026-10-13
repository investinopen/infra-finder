# frozen_string_literal: true

module Support
  module GlobalTypes
    # This represents literally any JSON-serializable object.
    #
    # It is available to `StoreModel` objects as `:any_json`.
    class AnyJSON < ActiveModel::Type::Value
      # @param [#as_json] value
      # @return [Object] a JSON-serializable object
      def cast(value)
        value.as_json
      end

      # @!attribute [r] type
      # A computer-readable type name.
      # @return [:any_json]
      def type
        :any_json
      end
    end
  end
end
