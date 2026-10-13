# frozen_string_literal: true

module Types
  # One of the controlled vocabularies that solutions are described with.
  #
  # @see ControlledVocabulary
  class ControlledVocabularyType < Types::BaseObject
    description <<~TEXT
    One of the controlled vocabularies that solutions are described with.
    TEXT

    field :kind, ::Types::ControlledVocabularyKindType, null: false do
      description "Identifies the vocabulary."
    end

    field :label, String, null: false do
      description "A human-readable name for the vocabulary."
    end

    field :accepts_other, Boolean, null: false, method: :accepts_other? do
      description "Whether forms pair this vocabulary's \"Other\" record with a free-text field."
    end

    field :records_count, Integer, null: false do
      description "How many records the vocabulary has."
    end

    field :extra_fields, [::Types::ControlledVocabularyExtraFieldType, { null: false }], null: false do
      description "Fields this vocabulary's records have beyond those in `ControlledVocabularyRecord`."
    end

    field :records, resolver: ::Resolvers::ControlledVocabularyRecordResolver do
      description "The vocabulary's records."
    end

    # @return [String]
    def kind = object.model_name

    # @return [String]
    def label = object.model_klass.model_name.human.pluralize

    # @return [Integer]
    def records_count = object.model_klass.count

    # @return [<Hash>]
    def extra_fields
      object.model_klass.graphql_node_type::EXTRA_FIELDS.map do |field|
        field.merge(
          name: field[:name].camelize(:lower),
          label: object.model_klass.human_attribute_name(field[:name])
        )
      end
    end
  end
end
