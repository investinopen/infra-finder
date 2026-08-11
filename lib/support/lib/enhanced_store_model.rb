# frozen_string_literal: true

module Support
  # StoreModel is missing a few nice things from ActiveModel,
  # like validation callbacks, and the ability to use brackets
  # to access attributes.
  module EnhancedStoreModel
    extend ActiveSupport::Concern

    include DefinesSchemaNamespace

    included do
      extend Dry::Core::ClassAttributes

      include StoreModel::Model
      include ActiveModel::Validations::Callbacks
      include Support::EnhancedStoreModel::EnhancedInspection
      include Support::EnhancedStoreModel::EnhancedStrongParams

      delegate :inspection_filter, to: :class

      defines :filter_attributes, type: Support::Types::Array.of(Support::Types::Any)

      filter_attributes Dry::Core::Constants::EMPTY_ARRAY
    end

    # @param [#to_s] attr
    # @return [Object]
    def [](attr) = public_send(attr)

    # @param [#to_s] attr
    # @param [Object]
    # @return [void]
    def []=(attr, value)
      public_send(:"#{attr}=", value)
    end

    # @param [{ Symbol => Object }] attrs
    # @return [void]
    def merge!(attrs)
      return unless attrs.kind_of?(Hash)

      attrs.each do |attr, value|
        self[attr] = value
      end
    end

    def to_hash = as_json

    module ClassMethods
      # A better method for generating enums that does not store numeric values.
      #
      # We want to store the actual strings.
      #
      # @param [Symbol] attr_name
      # @param [<#to_s>] values
      # @param [{ Symbol => Object }] options
      def actual_enum(attr_name, *values, **options)
        values.flatten!

        mapped = values.index_with(&:to_s)

        options[:in] = mapped

        enum attr_name, **options
      end

      # @return [<String>]
      def array_attributes
        attribute_names.select do |name|
          /array/.match? attribute_types.fetch(name).try(:type)
        end
      end

      def filter_attributes!(*attrs)
        filter_attributes [*filter_attributes, *attrs].uniq.freeze

        @inspection_filter = build_inspection_filter
      end

      def inspection_filter
        @inspection_filter ||= build_inspection_filter
      end

      private

      def build_inspection_filter
        mask = ActiveRecord::Core.const_get(:InspectionMask).new(ActiveSupport::ParameterFilter::FILTERED)

        ActiveSupport::ParameterFilter.new(filter_attributes, mask:)
      end
    end

    # @api private
    module EnhancedInspection
      extend ActiveSupport::Concern

      def inspect
        inspection = attributes.keys.map { |name| "#{name}: #{attribute_for_inspect(name)}" }.join(", ")

        "#<#{self.class} #{inspection}>"
      end

      private

      def attribute_for_inspect(attr_name)
        attr_name = attr_name.to_s
        attr_name = self.class.attribute_aliases[attr_name] || attr_name
        value = _read_attribute(attr_name)
        format_for_inspect(attr_name, value)
      end

      def format_for_inspect(name, value)
        if value.nil?
          value.inspect
        else
          inspected_value =
            if value.is_a?(String) && value.length > 50
              "#{value[0, 50]}...".inspect
            elsif value.is_a?(Date) || value.is_a?(Time)
              %("#{value.to_fs(:inspect)}")
            else
              value.inspect
            end

          inspection_filter.filter_param(name, inspected_value)
        end
      end
    end

    module EnhancedStrongParams
      extend ActiveSupport::Concern

      include WithStrongParamSet

      module ClassMethods
        # @param [#to_s] name
        # @param [#to_s, nil] type
        # @param [Boolean] strong
        # @param [{ Symbol => Object }] options
        # @return [void]
        def attribute(name, type = nil, strong: strong_params_default_allowed, **options)
          super(name, type, **options)

          return unless strong

          type = attribute_types.fetch(name.to_s)

          case type
          in StoreModel::Types::Base => store_model_type
            case store_model_type.type
            in /polymorphic/
              # intentionally skipped, we can't derive polymorphic params
              # and we don't need to since they aren't used in forms
            else
              strong_param_set[name] = store_model_type.model_klass.strong_params
            end
          else
            strong_param_set << name
          end
        end

        private

        # @param [Symbol] attribute
        # @param [Hash] options
        # @return [void]
        def define_store_model_attr_accessors(attribute, options)
          super

          type = nested_attribute_type(attribute)

          return unless type.kind_of?(StoreModel::Types::Base)

          strong_param_set[:"#{attribute}_attributes"] = type.model_klass.strong_params
        end
      end
    end
  end
end
