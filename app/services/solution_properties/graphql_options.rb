# frozen_string_literal: true

module SolutionProperties
  # The choices for a property whose options are not controlled vocabulary
  # records: implementation statuses, database enums, countries, and currencies.
  #
  # Values are what the GraphQL API sends and accepts for the property:
  # enum names for enum-typed fields, raw codes for countries and currencies.
  #
  # @see SolutionProperties::ValueType
  class GraphQLOptions
    include Dry::Initializer[undefined: false].define -> do
      param :property, ::SolutionProperty::Type
    end

    # @return [<{ Symbol => String }>]
    def call
      case property.kind
      in :implementation_enum
        from_vocab(property.vocab, enum_names: true)
      in :enum
        from_pg_enum(property.enum_type)
      in :single_option if property.vocab.present? && !property.vocab.uses_model?
        from_vocab(property.vocab, enum_names: false)
      else
        []
      end
    end

    private

    # @param [ControlledVocabulary] vocab
    # @param [Boolean] enum_names
    # @return [<{ Symbol => String }>]
    def from_vocab(vocab, enum_names:)
      vocab.fetch_options!.map do |(label, value)|
        { label:, value: enum_names ? value.to_s.upcase : value }
      end
    end

    # @param [#to_s] enum_name
    # @return [<{ Symbol => String }>]
    def from_pg_enum(enum_name)
      ApplicationRecord.pg_enum_select_options(enum_name).map do |(label, value)|
        { label:, value: value.upcase }
      end
    end
  end
end
