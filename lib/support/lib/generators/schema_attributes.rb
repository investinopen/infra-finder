# frozen_string_literal: true

module Support
  module Generators
    class SchemaAttributes < OrderedMap
      QM = ??

      # @param [#to_sym] key
      # @param [String] type
      # @param [Boolean] optional
      # @return [void]
      def add!(key, type, optional: true)
        key = optionalize(key) if optional

        self[key] = type
      end

      # @param [Array<#to_sym>] keys
      # @param [String] type
      # @param [Boolean] optional
      # @return [void]
      def add_batch!(*keys, type:, optional: true)
        keys.flatten.each do |key|
          add!(key, type, optional:)
        end
      end

      private

      def optionalize(key) = :"#{key.to_s.chomp(QM)}?"
    end
  end
end
