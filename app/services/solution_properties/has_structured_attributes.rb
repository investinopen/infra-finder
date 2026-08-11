# frozen_string_literal: true

module SolutionProperties
  # A concern for solution implementations that interface with {Structured} (and {Implementations})
  # models.
  #
  # @see SolutionProperties::HasImplementations
  # @see SolutionProperties::HasStoreModelLists
  module HasStructuredAttributes
    extend ActiveSupport::Concern

    include StoreModel::NestedAttributes

    private

    # @param [Hash] attributes
    def structured_list_parse(attributes)
      attributes.values.select do |item|
        item.present? && item.values.any? { _1.present? || _1 == false }
      end
    end

    # @see Structured::CSVConversion
    # @param [Symbol] attr
    # @return [String]
    def structured_data_read(attr)
      self[attr].try(:to_csv)
    end

    # @param [Symbol] attr
    # @param [String] json
    # @return [void]
    def structured_data_write!(attr, json)
      return if json.blank?

      self[attr] = JSON.parse(json)
    end
  end
end
