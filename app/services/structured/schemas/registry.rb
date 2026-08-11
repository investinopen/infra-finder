# frozen_string_literal: true

module Structured
  module Schemas
    # @see ::Structured::Registry
    module Registry
      # A type matching the known, settable properties of a {Structured::Registry}.
      # @return [Dry::Types::Hash{Symbol => Object}]
      Type = ::Inputs::Types::BaseSchema.schema(
        name?: ::Inputs::Types::Attributes::String,
        description?: ::Inputs::Types::Attributes::String,
        url?: ::Inputs::Types::Attributes::String,
      )

      # This type will transparently handle accepting an array of hashes for {Type}.
      #
      # @see ::Inputs::Types::List
      # @return [Dry::Types::Type<Type>]
      List = ::Inputs::Types::List[Type]

      # This type will transparently handle nested attributes for {Type},
      # ensuring that the input is coerced into a hash with string index keys
      # and values of {Type}.
      #
      # @see ::Inputs::Types::NestedAttributesList
      # @return [Dry::Types::Type{ String => Type }]
      NestedAttributesList = ::Inputs::Types::NestedAttributesList[Type]

      # A constant suitable for matching against strong params for this store model.
      StrongParams = [
        :description,
        :name,
        :url,
      ].freeze
    end
  end
end
