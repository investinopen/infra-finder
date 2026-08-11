# frozen_string_literal: true

module Support
  module Generators
    class OrderedMap
      include Enumerable
      include Quoting

      def initialize(**)
        @mapping = {}.with_indifferent_access
        @keys = SortedSet.new
      end

      def each
        return enum_for(__method__) unless block_given?

        each_key do |key|
          value = @mapping.fetch(key)

          yield key, value
        end
      end

      def each_key
        return enum_for(__method__) unless block_given?

        @keys.each do |key|
          yield key
        end
      end

      def each_quoted
        return enum_for(__method__) unless block_given?

        each do |key, value|
          qk = quote_symbol(key)
          qv = quote_value(value)

          yield qk, qv
        end
      end

      def each_quoted_entry
        return enum_for(__method__) unless block_given?

        each do |key, value|
          qk = quote_symbolic_hash_key(key)
          qv = quote_value(value)

          yield "#{qk}: #{qv}"
        end
      end

      def empty? = @mapping.empty?

      def key?(k) = @mapping.key?(cast_key(k))

      # @param [#to_sym] key
      # @param [Object] value
      def store!(key, value)
        key = cast_key(key)

        @mapping[key] = cast_value(value)
        @keys << key
      end

      alias []= store!

      def value?(value) = @mapping.value?(cast_value(value))

      private

      def cast_key(key) = key.to_sym

      # @abstract
      def cast_value(value) = value

      # @abstract
      def quote_value(value)
        value
      end
    end
  end
end
