# frozen_string_literal: true

module Support
  module Generators
    class AttrMapping < OrderedMap
      alias attr? key?

      def inverse_nested!(attr)
        self[attr] = :"#{attr}_attributes"
      end

      def nested!(attr)
        self[:"#{attr}_attributes"] = attr
      end

      alias remap! store!

      alias remaps? value?

      private

      def cast_value(value) = value.to_sym

      def quote_value(value) = quote_symbol(value)
    end
  end
end
