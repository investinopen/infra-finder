# frozen_string_literal: true

module Support
  module Generators
    module HasTypeMapping
      extend ActiveSupport::Concern

      DEFAULT_FALLBACK_TYPE = "Support::Types::Any"

      DECLARATION = /\A[A-Z]\w+(?:::[A-Za-z]\w+)+\z/

      included do
        extend Dry::Core::ClassAttributes

        defines :fallback_type, type: Types::TypeName
        defines :type_mapping, type: Types::TypeMapping

        fallback_type DEFAULT_FALLBACK_TYPE
        type_mapping Dry::Core::Constants::EMPTY_HASH
      end

      private

      # @return [String]
      def fallback_type = self.class.fallback_type

      def store_model_type?(model_type)
        case model_type
        when StoreModel::Types::Many, StoreModel::Types::One
          true
        else
          false
        end
      end

      # @param [StoreModel::Types::Many, StoreModel::Types::One] model_type
      # @return [String]
      def store_model_type_expression_for(model_type, list: model_type.kind_of?(StoreModel::Types::Many))
        model_klass = model_type.model_klass

        if list
          expr = model_klass.schema_list_name

          "#{expr}.optional.fallback(Dry::Core::Constants::EMPTY_ARRAY)"
        else
          expr = model_klass.schema_type_name

          "#{expr}.optional.fallback(nil)"
        end
      end

      # @param [ActiveModel::Type::Value, StoreModel::Types::Many, StoreModel::Types::One] type
      # @return [String]
      def type_expression_for(input)
        case input
        in StoreModel::Types::Many => many_type
          store_model_type_expression_for(many_type, list: true)
        in StoreModel::Types::One => one_type
          store_model_type_expression_for(one_type, list: false)
        in ActiveRecord::Type::Value | ActiveModel::Type::Value => model_type
          type_expression_for model_type.type
        in Symbol
          type_mapping.fetch(input, fallback_type)
        in String if type_mapping.key?(input.to_sym)
          type_mapping.fetch(input.to_sym)
        in DECLARATION => type_name
          type_name
        else
          fallback_type
        end
      end

      # @return [ActiveSupport::HashWithIndifferentAccess]
      def type_mapping = self.class.type_mapping

      module ClassMethods
        # @param [#to_s] value
        # @return [void]
        def fallback_type!(value)
          fallback_type(value.to_s)
        end

        # @param [#to_sym] key
        # @param [#to_s] value
        # @return [void]
        def map_type!(key, value)
          map_types!(key.to_sym => value.to_s)
        end

        # @param [Hash<Symbol, String>] pairs
        # @return [void]
        def map_types!(**pairs)
          new_mapping = type_mapping.merge(pairs).transform_values(&:to_s)

          type_mapping(new_mapping.freeze)
        end
      end
    end
  end
end
