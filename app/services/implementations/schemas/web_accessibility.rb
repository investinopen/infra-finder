# frozen_string_literal: true

module Implementations
  module Schemas
    # @see ::Implementations::WebAccessibility
    module WebAccessibility
      # Used by {ATTR_REMAP} in order map nested attributes,
      # as well as any attribute aliases.
      # @return [{ Symbol => Symbol }]
      ATTR_MAPPING = {
        link_attributes: :link,
      }.freeze

      # A proc suitable for use with `with_key_transform`.
      #
      # @see ATTR_MAPPING
      # @return [Proc]
      ATTR_REMAP = ->(key) do
        key = key.to_sym

        ATTR_MAPPING.fetch(key, key)
      end

      # A type matching the known, settable properties of a {Implementations::WebAccessibility}.
      # @return [Dry::Types::Hash{Symbol => Object}]
      Type = ::Inputs::Types::BaseSchema.schema(
        link?: ::Implementations::Schemas::Link::Type.optional.fallback(nil),
        statement?: ::Inputs::Types::Attributes::String,
        applies_to_solution?: ::Inputs::Types::Attributes::Bool,
        applies_to_website?: ::Inputs::Types::Attributes::Bool,
      ).with_key_transform(&ATTR_REMAP)

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
        :applies_to_solution,
        :applies_to_website,
        :statement,
        {
          link: [
            :label,
            :url,
          ],
          link_attributes: [
            :label,
            :url,
          ],
        }
      ].freeze
    end
  end
end
