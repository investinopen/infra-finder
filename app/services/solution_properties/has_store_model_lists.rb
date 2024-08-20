# frozen_string_literal: true

module SolutionProperties
  # A concern consumed by {SolutionInterface} which describes the
  # various complex store models backing certain properties.
  #
  # @see SolutionProperty.store_model_lists
  module HasStoreModelLists
    extend ActiveSupport::Concern

    included do
      SolutionProperty.store_model_lists.each do |prop|
        attribute prop.name.to_sym, prop.store_model_type_name.constantize.to_array_type, default: proc { [] }

        validates prop.name.to_sym, store_model: true
      end
    end

    SolutionProperty.store_model_lists.each do |prop|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{prop.name}_attributes=(list_attributes)
        self[#{prop.name.inspect}] = parse_list_items_from(list_attributes)
      end

      def #{prop.structured_attr}
        #{prop.name}.as_json.compact_blank.to_json
      end

      def #{prop.structured_attr}=(json)
        return if json.blank?

        self[#{prop.name.inspect}] = JSON.parse(json)
      end
      RUBY
    end

    private

    # @param [Hash] attributes
    def parse_list_items_from(attributes)
      attributes.values.select do |item|
        item.present? && item.values.any? { _1.present? || _1 == false }
      end
    end
  end
end
