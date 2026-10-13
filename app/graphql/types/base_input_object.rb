# frozen_string_literal: true

module Types
  # @abstract The base input object type used throughout the schema.
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument

    class << self
      # @param [String, Symbol] name
      # @return [Boolean] whether this input object has an argument with the given name
      def has_argument_named?(name)
        arguments.key?(name.to_s)
      end
    end
  end
end
