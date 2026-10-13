# frozen_string_literal: true

module Support
  module GlobalTypes
    # This type represents an array that can contain literally anything.
    #
    # @note This and its subclasses are for use with StoreModel objects, as they do not
    #   support the same `array: true` syntax that ActiveRecord's `attribute` API does.
    class AnyArray < ActiveModel::Type::Value
      extend Dry::Core::ClassAttributes

      # @!parse [ruby]
      #   class << self
      #     # @api private
      #     # @overload element_type(new_type)
      #     #   Set the `element_type` for this array type.
      #     #   @param [Dry::Types::Type] new_type
      #     #   @return [void]
      #     # @overload element_type
      #     #   Retrieve the dry.rb type used for elements in this array type.
      #     #   @return [Dry::Types::Type]
      #     def element_type(*)
      #     end
      #   end
      defines :element_type

      element_type Dry::Types["any"]

      # Cast a value to an array.
      # @param [Array] value
      # @return [Array]
      def cast(value)
        Dry::Types["coercible.array"].of(self.class.element_type).try(value).to_monad.value_or([])
      end

      # @!attribute [r] type
      # A computer-readable type name.
      # @return [:any_array]
      # @see .type
      def type
        self.class.type
      end

      class << self
        # Calculate the {#type} for this class.
        #
        # @api private
        def type
          @type ||= name.demodulize.parameterize.underscore.to_sym
        end
      end
    end
  end
end
