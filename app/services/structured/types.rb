# frozen_string_literal: true

module Structured
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    BaseSchema = Inputs::Types::BaseSchema.fallback(Dry::Core::Constants::EMPTY_HASH)

    List = ->(value_type) do
      Array.of(value_type).constructor do |value|
        # rubocop:disable Lint/UselessAssignment
        nested_type = Structured::Types::NestedAttributesList[value_type]
        # rubocop:enable Lint/UselessAssignment

        case value
        in Array => arr
          arr.filter_map { value_type.try(_1).to_monad.value_or(nil) }
        in nested_type => nested
          nested.values.filter_map { value_type.try(_1).to_monad.value_or(nil) }
        end
      end
    end

    NestedAttributesList = Inputs::Types::NestedAttributesList
  end
end
