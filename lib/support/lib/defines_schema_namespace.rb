# frozen_string_literal: true

module Support
  # A concern for objects that define a schema namespace adjacent to themselves,
  # for consumption by dry-types.
  module DefinesSchemaNamespace
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :schema_namespace_name, type: Types::String.constrained(filled: true)

      derive_schema_namespace_name!
    end

    module ClassMethods
      # @return [Class]
      def schema_namespace = schema_namespace_name.safe_constantize

      # @api private
      # @return [void]
      def inherited(subclass)
        super

        subclass.derive_schema_namespace_name!
      end

      # @param [Pathname] root
      # @return [Pathname]
      def schema_namespace_path(root: Rails.root.join("app", "services"))
        root.join("#{schema_namespace_name.underscore}.rb")
      end

      # @param [String] name
      # @return [String]
      def schema_const_name(name) = "#{schema_namespace_name}::#{name}"

      # @param [String] name
      # @return [Object, nil]
      def schema_const(name) = schema_const_name(name).safe_constantize

      def schema_type_name = schema_const_name("Type")

      def schema_list_name = schema_const_name("List")

      def schema_nested_attributes_list_name = schema_const_name("NestedAttributesList")

      def schema_type = schema_type_name.safe_constantize

      def schema_list = schema_list_name.safe_constantize

      def schema_nested_attributes_list = schema_nested_attributes_list_name.safe_constantize

      protected

      # @return [String]
      def derive_schema_namespace_name
        "#{name.deconstantize}::Schemas::#{name.demodulize}"
      end

      # @return [void]
      def derive_schema_namespace_name!
        schema_namespace_name derive_schema_namespace_name
      end
    end
  end
end
