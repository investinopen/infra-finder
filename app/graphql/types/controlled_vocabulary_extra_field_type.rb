# frozen_string_literal: true

module Types
  # A column some vocabularies' records have beyond the shared ones.
  #
  # @see Types::ControlledVocabularyType#extra_fields
  class ControlledVocabularyExtraFieldType < Types::BaseObject
    description <<~TEXT
    A field some vocabularies' records have beyond those in `ControlledVocabularyRecord`.
    TEXT

    field :name, String, null: false do
      description "The field's name on the record type, e.g. `url`."
    end

    field :label, String, null: false do
      description "A human-readable label."
    end

    field :type, ::Types::ControlledVocabularyFieldTypeType, null: false do
      description "The field's value type."
    end

    field :required, Boolean, null: false do
      description "Whether the field must have a value."
    end
  end
end
