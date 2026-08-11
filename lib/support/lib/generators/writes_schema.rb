# frozen_string_literal: true

module Support
  module Generators
    module WritesSchema
      extend ActiveSupport::Concern

      include FormattedNaming
      include HasAttrMapping
      include HasTypeMapping
      include Quoting

      private

      # @return [void]
      def add_to_schema!(key, expr, nested: false, **options)
        attr_mapping.inverse_nested!(key) if nested

        name = nested ? :"#{key}_attributes" : key

        type = type_expression_for(expr)

        schema_attributes.add!(name, type, **options)
      end

      # @return [Support::Generators::SchemaAttributes]
      def schema_attributes
        @schema_attributes ||= Support::Generators::SchemaAttributes.new
      end
    end
  end
end
