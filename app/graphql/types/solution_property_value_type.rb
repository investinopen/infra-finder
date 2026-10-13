# frozen_string_literal: true

module Types
  # @see SolutionProperties::ValueType
  class SolutionPropertyValueType < Types::BaseUnion
    graphql_name "SolutionPropertyValue"

    description "What a solution property's value is."

    possible_types ::Types::ScalarValueType, ::Types::EnumValueType, ::Types::VocabularyValueType,
      ::Types::AssociationValueType, ::Types::StructuredListValueType, ::Types::ImplementationValueType

    TYPES = {
      ::SolutionProperties::ValueType::Scalar => ::Types::ScalarValueType,
      ::SolutionProperties::ValueType::Enum => ::Types::EnumValueType,
      ::SolutionProperties::ValueType::Vocabulary => ::Types::VocabularyValueType,
      ::SolutionProperties::ValueType::Association => ::Types::AssociationValueType,
      ::SolutionProperties::ValueType::StructuredList => ::Types::StructuredListValueType,
      ::SolutionProperties::ValueType::Implementation => ::Types::ImplementationValueType,
    }.freeze

    class << self
      # @return [Class]
      def resolve_type(object, _context) = TYPES.fetch(object.class)
    end
  end
end
