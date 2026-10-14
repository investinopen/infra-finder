# frozen_string_literal: true

module EncodedSets
  module Assignment
    extend ActiveSupport::Concern

    # @param [Symbol] key
    # @param [Object] value
    # @return [void]
    def assign!(key, value)
      self[key] = cast_for_assignment(value, key:)
    end

    # @api private
    # @param [Object] value
    # @param [Symbol] key
    # @return [Object]
    def cast_for_assignment(value, key: nil)
      case value
      in nil then nil
      in ::Filtering::Inputs::ComparatorMatch => match
        cast_comparator_match_for_assignment(match, key:)
      in ::ApplicationRecord
        cast_reference_for_assignment(value, key:)
      in ::Support::Models::Types::ModelList => list if list.size > 0
        cast_references_for_assignment(list, key:)
      else
        value
      end
    end

    # @api private
    # @param [#as_json] value
    # @param [Symbol] key
    # @return [Hash]
    def cast_comparator_match_for_assignment(value, key:)
      value.as_json
    end

    # @api private
    # @param [ApplicationRecord] value
    # @param [Symbol] key
    # @return [EncodedSets::Reference]
    def cast_reference_for_assignment(value, key:)
      EncodedSets::Reference.from(value)
    end

    # @param [<ApplicationRecord>] value
    # @param [Symbol] key
    # @return [<EncodedSets::Reference>]
    def cast_references_for_assignment(value, key:)
      Array(value).map { |record| EncodedSets::Reference.from(record) }
    end
  end
end
