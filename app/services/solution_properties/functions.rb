# frozen_string_literal: true

module SolutionProperties
  module Functions
    extend Dry::Transformer::Registry

    import Dry::Transformer::ArrayTransformations
    import Dry::Transformer::HashTransformations
    import Dry::Transformer::Recursion

    NORMALIZE_PARAM = ->(value) do
      case value
      when ActiveRecord::Base then value.id
      when Array, Enumerable then value.map { NORMALIZE_PARAM.(_1) }
      else
        value.as_json
      end
    end

    class << self
      # @param [#to_h] input
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def indifferentize(input)
        input.to_h.with_indifferent_access
      end

      # @param [#to_h] input
      # @param [Symbol, String] source_key
      # @param [Symbol, String] target_key
      # @param [Proc] mapper_fn
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def remap_param(input, source_key, target_key, mapper_fn)
        return input unless input.key?(source_key)

        value = input.delete(source_key)

        input[target_key] = mapper_fn.call(value)

        return input
      end

      # @param [#to_h] input
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def remap_has_one_associations(input)
        SolutionProperty.has_one_associations.reduce(input) do |acc, association|
          remap_param(acc, association, :"#{association}_id", NORMALIZE_PARAM)
        end
      end

      # @param [#to_h] input
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def remap_has_many_associations(input)
        SolutionProperty.has_many_associations.reduce(input) do |acc, association|
          remap_param(acc, association, :"#{association.to_s.singularize}_ids", NORMALIZE_PARAM)
        end
      end

      # @param [#to_h] input
      # @return [ActiveSupport::HashWithIndifferentAccess]
      def remap_associations(input)
        remap_has_one_associations(input).then do |result|
          remap_has_many_associations(result)
        end
      end

      def remap_implementations(input)
        Implementation.each.reduce(input) do |acc, implementation|
          remap_param(acc, implementation.name, :"#{implementation.name}_attributes", NORMALIZE_PARAM)
        end
      end

      def remap_store_model_lists(input)
        SolutionProperty.store_model_lists.reduce(input) do |acc, store_model_list|
          remap_param(acc, store_model_list.name, :"#{store_model_list.name}_attributes", NORMALIZE_PARAM)
        end
      end
    end
  end
end
