# frozen_string_literal: true

module Structured
  module Schemas
    # @see ::Structured::Grant
    module Grant
      # A type matching the known, settable properties of a {Structured::Grant}.
      # @return [Dry::Types::Hash{Symbol => Object}]
      Type = ::Inputs::Types::BaseSchema.schema(
        name?: ::Inputs::Types::Attributes::String,
        starts_on?: ::Inputs::Types::Attributes::Date,
        ends_on?: ::Inputs::Types::Attributes::Date,
        display_date?: ::Inputs::Types::Attributes::String,
        funder?: ::Inputs::Types::Attributes::String,
        amount?: ::Inputs::Types::Attributes::String,
        grant_activities?: ::Inputs::Types::Attributes::String,
        award_announcement_url?: ::Inputs::Types::Attributes::String,
        notes?: ::Inputs::Types::Attributes::String,
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
        :amount,
        :award_announcement_url,
        :display_date,
        :ends_on,
        :funder,
        :grant_activities,
        :name,
        :notes,
        :starts_on,
      ].freeze
    end
  end
end
